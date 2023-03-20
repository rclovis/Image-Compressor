{-
-- EPITECH PROJECT, 2023
-- main
-- File description:
-- main
-}

import System.Environment (getArgs)
import Data.Maybe (fromMaybe)
import System.Exit (exitWith, ExitCode (ExitFailure))
import Control.Monad
import Lib

getVal :: Int -> [String] -> String
getVal 0 args = fromMaybe "no" (lookup "-n" (toTup args))
getVal 1 args = fromMaybe "no" (lookup "-l" (toTup args))
getVal 2 args = fromMaybe "no" (lookup "-f" (toTup args))
getVal _ _ = ""

first_b :: (Int, Int, Int) -> Int -> Int
first_b (b, _, _) 0 = b
first_b (_, c, _) 1 = c
first_b (_, _, d) 2 = d
first_b _ _ = 0

alreadyIn :: (Int, Int, Int) -> [(Int, Int, Int)] -> Bool
alreadyIn _ [] = False
alreadyIn (b, c, d) ((x, y, z):as) |  b == x && c == y && d == z = True
    | otherwise = alreadyIn (b, c, d) as

initCentroids :: Int -> [(Int, Int, Int)] -> [(Int, Int, Int)] -> [(Int, Int, Int)]
initCentroids _ [] l = l
initCentroids 0 _ l = l
initCentroids n (x:xs) l | alreadyIn x l = initCentroids n xs l
    | otherwise = initCentroids (n - 1)
        xs ((first_b x 0, first_b x 1, first_b x 2):l)

parseLine :: String -> (Int, Int, Int)
parseLine str =
    let coord = fst (strtok (trim str) ' ') in
    let tmp = snd (strtok (trim str) ' ') in
    let v1 = read (fst (strtok tmp ',')) :: Int in
    let tmp1 = snd (strtok tmp ',') in
    let v2 = read (fst (strtok tmp1 ',')) :: Int in
    let tmp2 = snd (strtok tmp1 ',') in
    let v3 = read (fst (strtok tmp2 ',')) :: Int in (v1, v2, v3)

giveClosestCentroid :: (Int, Int, Int) -> [(Int, Int, Int)] -> Int -> Int -> Int -> Int
giveClosestCentroid _ [] _ _ best = best
giveClosestCentroid (x, y, z) ((x', y', z'):as) b i best
    | dist < b = giveClosestCentroid (x, y, z) as dist (i + 1) i
    | otherwise = giveClosestCentroid (x, y, z) as b (i + 1) best
    where
        tmp = ((x - x') * (x - x') + (y - y') * (y - y') + (z - z') * (z - z'))
        dist = round (sqrt (fromIntegral tmp))

updateCentroids :: [(Int, Int, Int)] -> [(Int, Int, Int)] -> [Int]
updateCentroids [] _ = []
updateCentroids _ [] = []
updateCentroids (x:xs) y = giveClosestCentroid x y
    1000000000 0 0 : updateCentroids xs y

first :: (a, a, a) -> a
first (x, _, _) = x

second :: (a, a, a) -> a
second (_, y, _) = y

third :: (a, a, a) -> a
third (_, _, z) = z

newCentroids :: [(Int, Int, Int)] -> [Int] -> Int -> Int -> (Int, Int, Int)
newCentroids _ [] _ _ = (0, 0, 0)
newCentroids [] _ _ _ = (0, 0, 0)
newCentroids a b c 0 = ((div var1 count), (div var2 count), (div var3 count))
    where
        new = (newCentroids a b c 1)
        var1 = (first new)
        var2 = (second new)
        var3 = (third new)
        count = length (filter (== c) b)

newCentroids ((a, b, c):ys) (x:xs) k _ | x == k =
        (var1 + a, var2 + b, var3 + c)
    | otherwise = new
    where
        new = newCentroids ys xs k 1
        var1 = (first new)
        var2 = (second new)
        var3 = (third new)


updateAll :: [(Int, Int, Int)] -> [(Int, Int, Int)] ->
        [Int] -> Int -> [(Int, Int, Int)]
updateAll _ [] _ _ = []
updateAll a (_:xs) list c = (new : tmp)
    where
        new = newCentroids a list c 0
        tmp = updateAll a xs list (c + 1)


isGood :: [(Int, Int, Int)] -> [(Int, Int, Int)] -> Float -> Bool
isGood [] [] _ = True
isGood [] _ _ = True
isGood _ [] _ = True
isGood ((x, y, z):a) ((x', y', z'):b) n |
    tmp < n = isGood a b n
    | otherwise = False
    where
        tmp = fromIntegral (div (abs(x - x') + abs(y - y') + abs(z - z')) 3)

untilLimit :: [(Int, Int, Int)] -> [(Int, Int, Int)] ->
        [(Int, Int, Int)] -> Float -> [(Int, Int, Int)]
untilLimit a b c n | isGood b c n == True = c
    | otherwise = untilLimit a c (updateAll a c (updateCentroids a c) 0) n


printFinal1 :: [String] -> [(Int, Int, Int)] -> [Int] -> Int -> IO()
printFinal1 _ [] _ _ = return ()
printFinal1 a (x:xs) b c = printFinal1 a xs b (c + 1)
    >> printCentroid x >> printFinal2 a b c

printFinal2 :: [String] -> [Int] -> Int -> IO()
printFinal2 [] _ _ = return()
printFinal2 _ [] _ = return()
printFinal2 (x:xs) (y:ys) n | n == y = putStrLn x >> printFinal2 xs ys n
    | otherwise = printFinal2 xs ys n


imageCompessor :: Int -> Float -> String -> IO()
imageCompessor centr limit path = do
    contents <- readFile path
    when (length (lines contents) /= length
        (filter errorLine1 (lines contents))) $ exitWith (ExitFailure 84)
    when (length (lines contents) /= length
        (filter errorLine2 (lines contents))) $ exitWith (ExitFailure 84)
    let p = (map parseLine (lines contents))
    let c = initCentroids centr p []
    let u = untilLimit p c (updateAll p c (updateCentroids p c) 0) limit
    printFinal1 (lines contents) u (updateCentroids p u) 0

main :: IO ()
main = do
    a <- getArgs
    when (length a /= 6) $ exitWith (ExitFailure 84)
    when (errorHandling a 0) $ exitWith (ExitFailure 84)
    when (getVal 0 a == "no" || getVal 1 a == "no" || getVal 2 a == "no") $
        exitWith (ExitFailure 84)
    let centr = read(getVal 0 a) :: Int
    let limit = read(getVal 1 a) :: Float
    let path = getVal 2 a
    imageCompessor centr limit path

