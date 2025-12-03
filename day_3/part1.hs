import System.IO
{-
    0-100
    Lx / Rx
    0 L1 = 99
    99 R1 = 0
    50 L1 = 49
    50 R1 = 51
    0 L99 = 1

    START = 50
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
3
-}
solve :: [Int] -> Int
solve = snd . foldl (\(ptr, ns) x -> let cptr = mod (ptr + x) 100 in (cptr, if cptr == 0 then ns + 1 else ns)) (50,0)

main :: IO()
main = do
    let list = []
    handle <- openFile "input.txt" ReadMode
    contents <- hGetContents handle
    let file_lines = lines contents

    print ((solve . ao) file_lines)

    hClose handle


