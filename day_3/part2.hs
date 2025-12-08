{- HLINT ignore "Use camelCase" -}
import System.IO
import Data.Char (digitToInt)
import Data.List (tails)

parse_batteries :: [String] -> [[Int]]
parse_batteries = map (map digitToInt)


-- Poznámka: Recursion running předchozí algoritmus z part1 a brát data tak, aby vždy bylo místo na 12 elemetů

find_highest_capacity_12' :: [Int] -> Int
find_highest_capacity_12' batteries = sum $ zipWith (\x y -> y * 10^x) (reverse [0..11]) (go batteries 12) where
    go :: [Int] -> Int -> [Int]
    go [] _ = []
    go _ 0 = []
    go xs remaining = let
        capacity = length xs
        working_array = take (capacity - remaining + 1) xs
        (i,val) = foldl (\(index, value) (x,y) -> if value < y then (x,y) else (index, value)) (-1,-1) $ zip [0..] working_array
        remaining_array = drop (i + 1) xs
        in val:go remaining_array (remaining - 1)
            
    

main :: IO ()
main = do
    let list = []
    handle <- openFile "input.txt" ReadMode
    contents <- hGetContents handle
    let file_lines = lines contents

    print file_lines

    (print . sum . map find_highest_capacity_12' . parse_batteries) file_lines

    hClose handle
