{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Exception (SomeException, try)
import Control.Monad (forM_, void)
import Data.Aeson (Value, encode, object, (.=))
import qualified Data.Text as T
import qualified Data.Text.IO as TIO
import Network.HTTP.Simple
import System.Directory (
    createDirectoryIfMissing,
    listDirectory,
    removeDirectoryRecursive,
 )
import System.Environment (getArgs)
import System.Exit (exitFailure)
import System.IO (hPutStrLn, stderr)

telegramChatId :: String
telegramChatId = "133081420"

stateDir :: FilePath
stateDir = "/var/lib/fail2ban-notify"

main :: IO ()
main = do
    args <- getArgs
    case args of
        ["digest"] -> sendDigest
        ["record", ip, jail] -> recordBan (T.pack ip) (T.pack jail)
        _ -> hPutStrLn stderr "Usage: fail2ban-notify digest | record <ip> <jail>" >> exitFailure

recordBan :: T.Text -> T.Text -> IO ()
recordBan ip jail = do
    createDirectoryIfMissing True stateDir
    let entry = T.unpack jail <> "|" <> T.unpack ip
    appendFile (stateDir ++ "/bans.log") (entry ++ "\n")

sendDigest :: IO ()
sendDigest = do
    createDirectoryIfMissing True stateDir
    let logFile = stateDir ++ "/bans.log"
    content <- try (TIO.readFile logFile) :: IO (Either SomeException T.Text)
    case content of
        Left _ -> pure ()
        Right t -> do
            let entries = filter (not . T.null) $ T.lines t
            if null entries
                then pure ()
                else do
                    let grouped = groupByJail entries
                        msg = formatDigest grouped
                    discordUrl <- readSecret "/run/secrets/grafana-discord-webhook"
                    telegramToken <- readSecret "/run/secrets/grafana-telegram-token"
                    postJson discordUrl $ object ["content" .= msg]
                    postJson (telegramApi telegramToken) $
                        object
                            ["chat_id" .= telegramChatId, "text" .= msg, "parse_mode" .= ("HTML" :: T.Text)]
                    writeFile logFile ""

groupByJail :: [T.Text] -> [(T.Text, [T.Text])]
groupByJail entries =
    let pairs = map (\e -> let (j, rest) = T.breakOn "|" e in (j, T.drop 1 rest)) entries
        jails = nub' $ map fst pairs
     in [(j, [ip | (j', ip) <- pairs, j' == j]) | j <- jails]

nub' :: (Eq a) => [a] -> [a]
nub' [] = []
nub' (x : xs) = x : nub' (filter (/= x) xs)

formatDigest :: [(T.Text, [T.Text])] -> T.Text
formatDigest groups =
    let header = "Daily fail2ban report\n"
        total = sum $ map (length . snd) groups
        body = T.concat $ map formatJail groups
     in header <> "Total bans: " <> T.pack (show total) <> "\n\n" <> body

formatJail :: (T.Text, [T.Text]) -> T.Text
formatJail (jail, ips) =
    jail
        <> " ("
        <> T.pack (show (length ips))
        <> "):\n"
        <> T.concat (map (\ip -> "  - " <> ip <> "\n") (nub' ips))
        <> "\n"

readSecret :: FilePath -> IO String
readSecret = fmap (T.unpack . T.strip) . TIO.readFile

telegramApi :: String -> String
telegramApi token = "https://api.telegram.org/bot" ++ token ++ "/sendMessage"

postJson :: String -> Value -> IO ()
postJson url body = do
    result <- try go :: IO (Either SomeException ())
    case result of
        Left e -> hPutStrLn stderr $ "Failed to POST " ++ url ++ ": " ++ show e
        Right _ -> pure ()
  where
    go = do
        req <- parseRequest url
        void . httpNoBody $
            setRequestMethod "POST" $
                setRequestHeader "Content-Type" ["application/json"] $
                    setRequestBodyLBS (encode body) req
