import System.IO
import Debug.Trace (trace)
{-
    0-100
    Lx / Rx
    0 L1 = 99
    99 R1 = 0
    50 L1 = 49
    50 R1 = 51
    0 L99 = 1

    START = 50

    every click 0 = ns + 1
-}

{-
>>> ao ["L10", "R20", "L5"]
[-10,20,-5]
-}
ao :: [String] -> [Int]
ao [] = []
ao (x:xs) = let (y:ys) = x in
    case y of 'L' -> (read ys :: Int) * (-1) : ao xs
              'R' -> (read ys :: Int) : ao xs
              _ -> ao xs


{-
>>> solve $ ao ["L68", "L30", "R48", "L5", "R60", "L55", "L1", "L99", "R14", "L82"]
6
>>> mod (-18) 100
82
>>> (fromIntegral (-903) / 100) + fromIntegral (abs (-903) `div` 100)
-2.999999999999936e-2
-}
solve :: [Int] -> Int
solve = snd . foldl (\(ptr, ns) x -> let cptr = mod (ptr + x) 100 in (cptr,
        if ptr + x >= 100 || ptr + x <= 0 then
            if abs x > 99 then
                ns + abs (floor (fromIntegral (x + ptr) / 100))
            else ns + 1 - (if ptr == 0 then 1 else 0)
        else ns
    )) (50,0)

{-
>>> solve' $ ao ["L68", "L30", "R48", "L5", "R60", "L55", "L1", "L99", "R14", "L82"]
6
>>> (-5) `div` 100
-1
>>> (fromIntegral (-903) / 100) + fromIntegral (abs (-903) `div` 100)
-2.999999999999936e-2
-}
solve' :: [Int] -> Int
solve' = snd . foldl shift (50,0) where
        shift (current, ns) x = (new_ptr, ns + cycles) where
            pre_ptr = current + x
            new_ptr = pre_ptr `mod` 100
            cycles
                | x > 0 = pre_ptr `div` 100
                | x < 0 = ((current - 1) `div` 100) - ((pre_ptr - 1) `div` 100)

                | otherwise = 0

main :: IO()
main = do
    let list = []
    handle <- openFile "input.txt" ReadMode
    contents <- hGetContents handle
    let file_lines = lines contents

    print ((solve' . ao) file_lines)

    hClose handle
