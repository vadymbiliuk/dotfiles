{-# LANGUAGE OverloadedStrings #-}
module Main where

import Control.Exception (try, SomeException)
import Control.Monad (void, when)
import Data.Aeson (Value, encode, object, (.=))
import qualified Data.Text as T
import qualified Data.Text.IO as TIO
import Network.HTTP.Simple
import System.Directory (createDirectoryIfMissing, doesFileExist)
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
    [ip, jail] -> notify (T.pack ip) (T.pack jail)
    _          -> hPutStrLn stderr "Usage: fail2ban-notify <ip> <jail>" >> exitFailure

notify :: T.Text -> T.Text -> IO ()
notify ip jail = do
  seen <- alreadySeen ip
  when (not seen) $ do
    discordUrl    <- readSecret "/run/secrets/grafana-discord-webhook"
    telegramToken <- readSecret "/run/secrets/grafana-telegram-token"
    let msg = "[BANNED] " <> ip <> " | jail: " <> jail
    postJson discordUrl   $ object ["content" .= msg]
    postJson (telegramApi telegramToken) $ object ["chat_id" .= telegramChatId, "text" .= msg]
    markSeen ip

alreadySeen :: T.Text -> IO Bool
alreadySeen ip = do
  createDirectoryIfMissing True stateDir
  doesFileExist (stateDir ++ "/" ++ T.unpack ip)

markSeen :: T.Text -> IO ()
markSeen ip = writeFile (stateDir ++ "/" ++ T.unpack ip) ""

readSecret :: FilePath -> IO String
readSecret = fmap (T.unpack . T.strip) . TIO.readFile

telegramApi :: String -> String
telegramApi token = "https://api.telegram.org/bot" ++ token ++ "/sendMessage"

postJson :: String -> Value -> IO ()
postJson url body = do
  result <- try go :: IO (Either SomeException ())
  case result of
    Left e  -> hPutStrLn stderr $ "Failed to POST " ++ url ++ ": " ++ show e
    Right _ -> pure ()
  where
    go = do
      req <- parseRequest url
      void . httpNoBody
        $ setRequestMethod "POST"
        $ setRequestHeader "Content-Type" ["application/json"]
        $ setRequestBodyLBS (encode body) req
