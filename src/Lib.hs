module Lib
    ( printCentroid, errorLine1, errorLine2, trim, strtok,
        errorHandling, toTup
    ) where

import Text.Read (readMaybe)
import Data.Char (isDigit)

toTup :: [a] -> [(a, a)]
toTup [] = []
toTup (x:y:z) = (x, y) : toTup z
toTup _ = []

trim :: String -> String
trim [] = []
trim (')':xs) = trim xs
trim ('(':xs) = trim xs
trim (x:xs) = x : trim xs

strtok :: String -> Char -> (String, String)
strtok [] _ = ("", "")
strtok (x:xs) c | x == c = ("" , xs)
    | otherwise = (x : fst (strtok xs c), snd (strtok xs c))

printCentroid :: (Int, Int, Int) -> IO ()
printCentroid (x, y, z) = putStrLn "--" >>
    putStrLn ("(" ++ show x ++ "," ++ show y ++ "," ++ show z ++ ")")
    >> putStrLn "-"

errorLine1 :: String -> Bool
errorLine1 [] = True
errorLine1 (',':xs) = errorLine1 xs
errorLine1 ('(':xs) = errorLine1 xs
errorLine1 (')':xs) = errorLine1 xs
errorLine1 (' ':xs) = errorLine1 xs
errorLine1 ('.':xs) = errorLine1 xs
errorLine1 (x:xs) | isDigit x = errorLine1 xs
    | otherwise = False

errorLine2 :: String -> Bool
errorLine2 str | (readMaybe (fst (strtok tmp ',')) :: Maybe Int)
    == Nothing = False
    | (readMaybe (fst (strtok tmp1 ',')) :: Maybe Int) == Nothing = False
    | (readMaybe (fst (strtok tmp2 ',')) :: Maybe Int) == Nothing = False
    | otherwise = True
    where
        tmp = snd (strtok (trim str) ' ')
        tmp1 = snd (strtok tmp ',')
        tmp2 = snd (strtok tmp1 ',')

errorHandling :: [String] -> Int -> Bool
errorHandling [] 1 = True
errorHandling [] 2 = True
errorHandling [] 3 = True
errorHandling [] 0 = False
errorHandling (x:xs) 1 | (readMaybe x :: Maybe Int) == Nothing = True
    | otherwise = errorHandling xs 0
errorHandling (x:xs) 3 | (readMaybe x :: Maybe Float) == Nothing = True
    | otherwise = errorHandling xs 0
errorHandling (_:xs) 2 = errorHandling xs 0
errorHandling ("-n":xs) 0 = errorHandling xs 1
errorHandling ("-l":xs) 0 = errorHandling xs 3
errorHandling ("-f":xs) 0 = errorHandling xs 2
errorHandling _ 0 = True
errorHandling _ _ = False