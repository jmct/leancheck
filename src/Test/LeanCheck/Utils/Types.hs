-- | Types to aid in property-based testing.
module Test.LeanCheck.Utils.Types
  (
  -- * Integer types
  --
  -- | Small-width integer types to aid in property-based testing.
  -- Sometimes it is useful to limit the possibilities of enumerated values
  -- when testing polymorphic functions, these types allow that.
  --
  -- The signed integer types @IntN@ are of limited bit width @N@
  -- bounded by @-2^(N-1)@ to @2^(N-1)-1@.
  -- The unsigned integer types @WordN@ are of limited bit width @N@
  -- bounded by @0@ to @2^N-1@.
  --
  -- Operations are closed and modulo @2^N@.  e.g.:
  --
  -- > maxBound + 1      = minBound
  -- > read "2"          = -2 :: Int2
  -- > abs minBound      = minBound
  -- > negate n          = 2^N - n :: WordN
    Int1
  , Int2
  , Int3
  , Int4
  , Word1
  , Word2
  , Word3
  , Word4
  , Nat
  , Nat1
  , Nat2
  , Nat3
  , Nat4
  , Nat5
  , Nat6
  , Nat7

  -- * Aliases to word types (deprecated)
  , UInt1
  , UInt2
  , UInt3
  , UInt4
  )
where
-- TODO: Add Ix and Bits instances

import Test.LeanCheck (Listable(..), listIntegral)
import Data.Ratio ((%))

narrowU :: Int -> Int -> Int
narrowU w i = i `mod` 2^w

narrowS :: Int -> Int -> Int
narrowS w i = let l  = 2^w
                  i' = i `mod` l
              in if i' < 2^(w-1)
                   then i'
                   else i' - l

mapTuple :: (a -> b) -> (a,a) -> (b,b)
mapTuple f (x,y) = (f x, f y)

mapFst :: (a -> b) -> (a,c) -> (b,c)
mapFst f (x,y) = (f x,y)

oNewtype :: (a -> b) -> (b -> a) -> (a -> a -> a) -> (b -> b -> b)
oNewtype con des o = \x y -> con $ des x `o` des y

fNewtype :: (a -> b) -> (b -> a) -> (a -> a) -> (b -> b)
fNewtype con des f = con . f . des

otNewtype :: (a -> b) -> (b -> a) -> (a -> a -> (a,a)) -> (b -> b -> (b,b))
otNewtype con des o = \x y -> mapTuple con $ des x `o` des y

readsPrecNewtype :: Read a => (a -> b) -> Int -> String -> [(b,String)]
readsPrecNewtype con n = map (mapFst con) . readsPrec n

boundedEnumFrom :: (Ord a,Bounded a,Enum a) => a -> [a]
boundedEnumFrom x = [x..maxBound]

boundedEnumFromThen :: (Ord a,Bounded a,Enum a) => a -> a -> [a]
boundedEnumFromThen x y | x > y     = [x,y..minBound]
                        | otherwise = [x,y..maxBound]

-- | Single-bit signed integers: -1, 0
newtype Int1 = Int1 { unInt1 :: Int } deriving (Eq, Ord)

-- | Two-bit signed integers: -2, -1, 0, 1
newtype Int2 = Int2 { unInt2 :: Int } deriving (Eq, Ord)

-- | Three-bit signed integers: -4, -3, -2, -1, 0, 1, 2, 3
newtype Int3 = Int3 { unInt3 :: Int } deriving (Eq, Ord)

-- | Four-bit signed integers:
-- -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7
newtype Int4 = Int4 { unInt4 :: Int } deriving (Eq, Ord)

-- | Single-bit unsigned integer: 0, 1
newtype Word1 = Word1 { unWord1 :: Int } deriving (Eq, Ord)

-- | Two-bit unsigned integers: 0, 1, 2, 3
newtype Word2 = Word2 { unWord2 :: Int } deriving (Eq, Ord)

-- | Three-bit unsigned integers: 0, 1, 2, 3, 4, 5, 6, 7
newtype Word3 = Word3 { unWord3 :: Int } deriving (Eq, Ord)

-- | Four-bit unsigned integers:
-- 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
newtype Word4 = Word4 { unWord4 :: Int } deriving (Eq, Ord)

-- | Natural numbers (including 0): 0, 1, 2, 3, 4, 5, 6, 7, ...
--
-- Internally, this type is represented as an 'Int'.
-- So, it is limited by the 'maxBound' of 'Int'.
newtype Nat = Nat { unNat :: Int } deriving (Eq, Ord)

-- | Natural numbers modulo 1: 0
newtype Nat1 = Nat1 { unNat1 :: Int } deriving (Eq, Ord)

-- | Natural numbers modulo 2: 0, 1
newtype Nat2 = Nat2 { unNat2 :: Int } deriving (Eq, Ord)

-- | Natural numbers modulo 3: 0, 1, 2
newtype Nat3 = Nat3 { unNat3 :: Int } deriving (Eq, Ord)

-- | Natural numbers modulo 4: 0, 1, 2, 3
newtype Nat4 = Nat4 { unNat4 :: Int } deriving (Eq, Ord)

-- | Natural numbers modulo 5: 0, 1, 2, 3, 4
newtype Nat5 = Nat5 { unNat5 :: Int } deriving (Eq, Ord)

-- | Natural numbers modulo 6: 0, 1, 2, 3, 4, 5
newtype Nat6 = Nat6 { unNat6 :: Int } deriving (Eq, Ord)

-- | Natural numbers modulo 7: 0, 1, 2, 3, 4, 5, 6
newtype Nat7 = Nat7 { unNat7 :: Int } deriving (Eq, Ord)

int1  :: Int -> Int1;   int1  = Int1  . narrowS 1
int2  :: Int -> Int2;   int2  = Int2  . narrowS 2
int3  :: Int -> Int3;   int3  = Int3  . narrowS 3
int4  :: Int -> Int4;   int4  = Int4  . narrowS 4
word1 :: Int -> Word1;  word1 = Word1 . narrowU 1
word2 :: Int -> Word2;  word2 = Word2 . narrowU 2
word3 :: Int -> Word3;  word3 = Word3 . narrowU 3
word4 :: Int -> Word4;  word4 = Word4 . narrowU 4
nat1 :: Int -> Nat1;  nat1 = Nat1 . (`mod` 1)
nat2 :: Int -> Nat2;  nat2 = Nat2 . (`mod` 2)
nat3 :: Int -> Nat3;  nat3 = Nat3 . (`mod` 3)
nat4 :: Int -> Nat4;  nat4 = Nat4 . (`mod` 4)
nat5 :: Int -> Nat5;  nat5 = Nat5 . (`mod` 5)
nat6 :: Int -> Nat6;  nat6 = Nat6 . (`mod` 6)
nat7 :: Int -> Nat7;  nat7 = Nat7 . (`mod` 7)

oInt1  ::(Int->Int->Int)->(Int1->Int1->Int1)   ; oInt1  = oNewtype int1  unInt1
oInt2  ::(Int->Int->Int)->(Int2->Int2->Int2)   ; oInt2  = oNewtype int2  unInt2
oInt3  ::(Int->Int->Int)->(Int3->Int3->Int3)   ; oInt3  = oNewtype int3  unInt3
oInt4  ::(Int->Int->Int)->(Int4->Int4->Int4)   ; oInt4  = oNewtype int4  unInt4
oWord1 ::(Int->Int->Int)->(Word1->Word1->Word1); oWord1 = oNewtype word1 unWord1
oWord2 ::(Int->Int->Int)->(Word2->Word2->Word2); oWord2 = oNewtype word2 unWord2
oWord3 ::(Int->Int->Int)->(Word3->Word3->Word3); oWord3 = oNewtype word3 unWord3
oWord4 ::(Int->Int->Int)->(Word4->Word4->Word4); oWord4 = oNewtype word4 unWord4
oNat   ::(Int->Int->Int)->(Nat->Nat->Nat)      ; oNat   = oNewtype Nat   unNat
oNat1  ::(Int->Int->Int)->(Nat1->Nat1->Nat1)   ; oNat1  = oNewtype nat1  unNat1
oNat2  ::(Int->Int->Int)->(Nat2->Nat2->Nat2)   ; oNat2  = oNewtype nat2  unNat2
oNat3  ::(Int->Int->Int)->(Nat3->Nat3->Nat3)   ; oNat3  = oNewtype nat3  unNat3
oNat4  ::(Int->Int->Int)->(Nat4->Nat4->Nat4)   ; oNat4  = oNewtype nat4  unNat4
oNat5  ::(Int->Int->Int)->(Nat5->Nat5->Nat5)   ; oNat5  = oNewtype nat5  unNat5
oNat6  ::(Int->Int->Int)->(Nat6->Nat6->Nat6)   ; oNat6  = oNewtype nat6  unNat6
oNat7  ::(Int->Int->Int)->(Nat7->Nat7->Nat7)   ; oNat7  = oNewtype nat7  unNat7

fInt1  :: (Int->Int) -> (Int1->Int1)   ; fInt1  = fNewtype int1  unInt1
fInt2  :: (Int->Int) -> (Int2->Int2)   ; fInt2  = fNewtype int2  unInt2
fInt3  :: (Int->Int) -> (Int3->Int3)   ; fInt3  = fNewtype int3  unInt3
fInt4  :: (Int->Int) -> (Int4->Int4)   ; fInt4  = fNewtype int4  unInt4
fWord1 :: (Int->Int) -> (Word1->Word1) ; fWord1 = fNewtype word1 unWord1
fWord2 :: (Int->Int) -> (Word2->Word2) ; fWord2 = fNewtype word2 unWord2
fWord3 :: (Int->Int) -> (Word3->Word3) ; fWord3 = fNewtype word3 unWord3
fWord4 :: (Int->Int) -> (Word4->Word4) ; fWord4 = fNewtype word4 unWord4
fNat   :: (Int->Int) -> (Nat->Nat)     ; fNat   = fNewtype Nat   unNat
fNat1  :: (Int->Int) -> (Nat1->Nat1)   ; fNat1  = fNewtype nat1  unNat1
fNat2  :: (Int->Int) -> (Nat2->Nat2)   ; fNat2  = fNewtype nat2  unNat2
fNat3  :: (Int->Int) -> (Nat3->Nat3)   ; fNat3  = fNewtype nat3  unNat3
fNat4  :: (Int->Int) -> (Nat4->Nat4)   ; fNat4  = fNewtype nat4  unNat4
fNat5  :: (Int->Int) -> (Nat5->Nat5)   ; fNat5  = fNewtype nat5  unNat5
fNat6  :: (Int->Int) -> (Nat6->Nat6)   ; fNat6  = fNewtype nat6  unNat6
fNat7  :: (Int->Int) -> (Nat7->Nat7)   ; fNat7  = fNewtype nat7  unNat7

instance Show Int1 where show = show . unInt1
instance Show Int2 where show = show . unInt2
instance Show Int3 where show = show . unInt3
instance Show Int4 where show = show . unInt4
instance Show Word1 where show = show . unWord1
instance Show Word2 where show = show . unWord2
instance Show Word3 where show = show . unWord3
instance Show Word4 where show = show . unWord4
instance Show Nat where show (Nat x) = show x
instance Show Nat1 where show = show . unNat1
instance Show Nat2 where show = show . unNat2
instance Show Nat3 where show = show . unNat3
instance Show Nat4 where show = show . unNat4
instance Show Nat5 where show = show . unNat5
instance Show Nat6 where show = show . unNat6
instance Show Nat7 where show = show . unNat7

instance Read Int1 where readsPrec = readsPrecNewtype int1
instance Read Int2 where readsPrec = readsPrecNewtype int2
instance Read Int3 where readsPrec = readsPrecNewtype int3
instance Read Int4 where readsPrec = readsPrecNewtype int4
instance Read Word1 where readsPrec = readsPrecNewtype word1
instance Read Word2 where readsPrec = readsPrecNewtype word2
instance Read Word3 where readsPrec = readsPrecNewtype word3
instance Read Word4 where readsPrec = readsPrecNewtype word4
instance Read Nat where readsPrec = readsPrecNewtype Nat
instance Read Nat1 where readsPrec = readsPrecNewtype nat1
instance Read Nat2 where readsPrec = readsPrecNewtype nat2
instance Read Nat3 where readsPrec = readsPrecNewtype nat3
instance Read Nat4 where readsPrec = readsPrecNewtype nat4
instance Read Nat5 where readsPrec = readsPrecNewtype nat5
instance Read Nat6 where readsPrec = readsPrecNewtype nat6
instance Read Nat7 where readsPrec = readsPrecNewtype nat7


instance Num Int1 where (+) = oInt1 (+);  abs    = fInt1 abs
                        (-) = oInt1 (-);  signum = fInt1 signum
                        (*) = oInt1 (*);  fromInteger = int1 . fromInteger

instance Num Int2 where (+) = oInt2 (+);  abs    = fInt2 abs
                        (-) = oInt2 (-);  signum = fInt2 signum
                        (*) = oInt2 (*);  fromInteger = int2 . fromInteger

instance Num Int3 where (+) = oInt3 (+);  abs    = fInt3 abs
                        (-) = oInt3 (-);  signum = fInt3 signum
                        (*) = oInt3 (*);  fromInteger = int3 . fromInteger

instance Num Int4 where (+) = oInt4 (+);  abs    = fInt4 abs
                        (-) = oInt4 (-);  signum = fInt4 signum
                        (*) = oInt4 (*);  fromInteger = int4 . fromInteger

instance Num Word1 where (+) = oWord1 (+);  abs    = fWord1 abs
                         (-) = oWord1 (-);  signum = fWord1 signum
                         (*) = oWord1 (*);  fromInteger = word1 . fromInteger

instance Num Word2 where (+) = oWord2 (+);  abs    = fWord2 abs
                         (-) = oWord2 (-);  signum = fWord2 signum
                         (*) = oWord2 (*);  fromInteger = word2 . fromInteger

instance Num Word3 where (+) = oWord3 (+);  abs    = fWord3 abs
                         (-) = oWord3 (-);  signum = fWord3 signum
                         (*) = oWord3 (*);  fromInteger = word3 . fromInteger

instance Num Word4 where (+) = oWord4 (+);  abs    = fWord4 abs
                         (-) = oWord4 (-);  signum = fWord4 signum
                         (*) = oWord4 (*);  fromInteger = word4 . fromInteger

instance Num Nat where (+) = oNat (+);  abs    = fNat abs
                       (-) = oNat (-);  signum = fNat signum
                       (*) = oNat (*);  fromInteger = Nat . fromInteger

instance Num Nat1 where (+) = oNat1 (+);  abs    = fNat1 abs
                        (-) = oNat1 (-);  signum = fNat1 signum
                        (*) = oNat1 (*);  fromInteger = nat1 . fromInteger

instance Num Nat2 where (+) = oNat2 (+);  abs    = fNat2 abs
                        (-) = oNat2 (-);  signum = fNat2 signum
                        (*) = oNat2 (*);  fromInteger = nat2 . fromInteger

instance Num Nat3 where (+) = oNat3 (+);  abs    = fNat3 abs
                        (-) = oNat3 (-);  signum = fNat3 signum
                        (*) = oNat3 (*);  fromInteger = nat3 . fromInteger

instance Num Nat4 where (+) = oNat4 (+);  abs    = fNat4 abs
                        (-) = oNat4 (-);  signum = fNat4 signum
                        (*) = oNat4 (*);  fromInteger = nat4 . fromInteger

instance Num Nat5 where (+) = oNat5 (+);  abs    = fNat5 abs
                        (-) = oNat5 (-);  signum = fNat5 signum
                        (*) = oNat5 (*);  fromInteger = nat5 . fromInteger

instance Num Nat6 where (+) = oNat6 (+);  abs    = fNat6 abs
                        (-) = oNat6 (-);  signum = fNat6 signum
                        (*) = oNat6 (*);  fromInteger = nat6 . fromInteger

instance Num Nat7 where (+) = oNat7 (+);  abs    = fNat7 abs
                        (-) = oNat7 (-);  signum = fNat7 signum
                        (*) = oNat7 (*);  fromInteger = nat7 . fromInteger


instance Real Int1 where toRational (Int1 x) = fromIntegral x % 1
instance Real Int2 where toRational (Int2 x) = fromIntegral x % 1
instance Real Int3 where toRational (Int3 x) = fromIntegral x % 1
instance Real Int4 where toRational (Int4 x) = fromIntegral x % 1
instance Real Word1 where toRational (Word1 x) = fromIntegral x % 1
instance Real Word2 where toRational (Word2 x) = fromIntegral x % 1
instance Real Word3 where toRational (Word3 x) = fromIntegral x % 1
instance Real Word4 where toRational (Word4 x) = fromIntegral x % 1
instance Real Nat where toRational (Nat x) = fromIntegral x % 1
instance Real Nat1 where toRational (Nat1 x) = fromIntegral x % 1
instance Real Nat2 where toRational (Nat2 x) = fromIntegral x % 1
instance Real Nat3 where toRational (Nat3 x) = fromIntegral x % 1
instance Real Nat4 where toRational (Nat4 x) = fromIntegral x % 1
instance Real Nat5 where toRational (Nat5 x) = fromIntegral x % 1
instance Real Nat6 where toRational (Nat6 x) = fromIntegral x % 1
instance Real Nat7 where toRational (Nat7 x) = fromIntegral x % 1

instance Integral Int1 where quotRem = otNewtype int1 unInt1 quotRem
                             toInteger = toInteger . unInt1

instance Integral Int2 where quotRem = otNewtype int2 unInt2 quotRem
                             toInteger = toInteger . unInt2

instance Integral Int3 where quotRem = otNewtype int3 unInt3 quotRem
                             toInteger = toInteger . unInt3

instance Integral Int4 where quotRem = otNewtype int4 unInt4 quotRem
                             toInteger = toInteger . unInt4

instance Integral Word1 where quotRem = otNewtype word1 unWord1 quotRem
                              toInteger = toInteger . unWord1

instance Integral Word2 where quotRem = otNewtype word2 unWord2 quotRem
                              toInteger = toInteger . unWord2

instance Integral Word3 where quotRem = otNewtype word3 unWord3 quotRem
                              toInteger = toInteger . unWord3

instance Integral Word4 where quotRem = otNewtype word4 unWord4 quotRem
                              toInteger = toInteger . unWord4

instance Integral Nat where quotRem = otNewtype Nat unNat quotRem
                            toInteger = toInteger . unNat

instance Integral Nat1 where quotRem = otNewtype nat1 unNat1 quotRem
                             toInteger = toInteger . unNat1

instance Integral Nat2 where quotRem = otNewtype nat2 unNat2 quotRem
                             toInteger = toInteger . unNat2

instance Integral Nat3 where quotRem = otNewtype nat3 unNat3 quotRem
                             toInteger = toInteger . unNat3

instance Integral Nat4 where quotRem = otNewtype nat4 unNat4 quotRem
                             toInteger = toInteger . unNat4

instance Integral Nat5 where quotRem = otNewtype nat5 unNat5 quotRem
                             toInteger = toInteger . unNat5

instance Integral Nat6 where quotRem = otNewtype nat6 unNat6 quotRem
                             toInteger = toInteger . unNat6

instance Integral Nat7 where quotRem = otNewtype nat7 unNat7 quotRem
                             toInteger = toInteger . unNat7

instance Bounded Int1 where maxBound = Int1 0; minBound = Int1 (-1)
instance Bounded Int2 where maxBound = Int2 1; minBound = Int2 (-2)
instance Bounded Int3 where maxBound = Int3 3; minBound = Int3 (-4)
instance Bounded Int4 where maxBound = Int4 7; minBound = Int4 (-8)
instance Bounded Word1 where maxBound = Word1 1; minBound = Word1 0
instance Bounded Word2 where maxBound = Word2 3; minBound = Word2 0
instance Bounded Word3 where maxBound = Word3 7; minBound = Word3 0
instance Bounded Word4 where maxBound = Word4 15; minBound = Word4 0
instance Bounded Nat1 where maxBound = Nat1 0; minBound = Nat1 0
instance Bounded Nat2 where maxBound = Nat2 1; minBound = Nat2 0
instance Bounded Nat3 where maxBound = Nat3 2; minBound = Nat3 0
instance Bounded Nat4 where maxBound = Nat4 3; minBound = Nat4 0
instance Bounded Nat5 where maxBound = Nat5 4; minBound = Nat5 0
instance Bounded Nat6 where maxBound = Nat6 5; minBound = Nat6 0
instance Bounded Nat7 where maxBound = Nat7 6; minBound = Nat7 0

instance Enum Int1 where toEnum   = int1;   enumFrom     = boundedEnumFrom
                         fromEnum = unInt1; enumFromThen = boundedEnumFromThen

instance Enum Int2 where toEnum   = int2;   enumFrom     = boundedEnumFrom
                         fromEnum = unInt2; enumFromThen = boundedEnumFromThen

instance Enum Int3 where toEnum   = int3;   enumFrom     = boundedEnumFrom
                         fromEnum = unInt3; enumFromThen = boundedEnumFromThen

instance Enum Int4 where toEnum   = int4;   enumFrom     = boundedEnumFrom
                         fromEnum = unInt4; enumFromThen = boundedEnumFromThen

instance Enum Word1 where toEnum   = word1;   enumFrom     = boundedEnumFrom
                          fromEnum = unWord1; enumFromThen = boundedEnumFromThen

instance Enum Word2 where toEnum   = word2;   enumFrom     = boundedEnumFrom
                          fromEnum = unWord2; enumFromThen = boundedEnumFromThen

instance Enum Word3 where toEnum   = word3;   enumFrom     = boundedEnumFrom
                          fromEnum = unWord3; enumFromThen = boundedEnumFromThen

instance Enum Word4 where toEnum   = word4;   enumFrom     = boundedEnumFrom
                          fromEnum = unWord4; enumFromThen = boundedEnumFromThen

instance Enum Nat where
  toEnum   = Nat;    enumFrom     (Nat x)         = map Nat [x..]
  fromEnum = unNat;  enumFromThen (Nat x) (Nat s) = map Nat [x,s..]

instance Enum Nat1 where toEnum   = nat1;   enumFrom     = boundedEnumFrom
                         fromEnum = unNat1; enumFromThen = boundedEnumFromThen

instance Enum Nat2 where toEnum   = nat2;   enumFrom     = boundedEnumFrom
                         fromEnum = unNat2; enumFromThen = boundedEnumFromThen

instance Enum Nat3 where toEnum   = nat3;   enumFrom     = boundedEnumFrom
                         fromEnum = unNat3; enumFromThen = boundedEnumFromThen

instance Enum Nat4 where toEnum   = nat4;   enumFrom     = boundedEnumFrom
                         fromEnum = unNat4; enumFromThen = boundedEnumFromThen

instance Enum Nat5 where toEnum   = nat5;   enumFrom     = boundedEnumFrom
                         fromEnum = unNat5; enumFromThen = boundedEnumFromThen

instance Enum Nat6 where toEnum   = nat6;   enumFrom     = boundedEnumFrom
                         fromEnum = unNat6; enumFromThen = boundedEnumFromThen

instance Enum Nat7 where toEnum   = nat7;   enumFrom     = boundedEnumFrom
                         fromEnum = unNat7; enumFromThen = boundedEnumFromThen

instance Listable Int1 where list = [0,minBound]
instance Listable Int2 where list = listIntegral
instance Listable Int3 where list = listIntegral
instance Listable Int4 where list = listIntegral
instance Listable Word1 where list = [0..]
instance Listable Word2 where list = [0..]
instance Listable Word3 where list = [0..]
instance Listable Word4 where list = [0..]
instance Listable Nat where list = [0..]
instance Listable Nat1 where list = [0..]
instance Listable Nat2 where list = [0..]
instance Listable Nat3 where list = [0..]
instance Listable Nat4 where list = [0..]
instance Listable Nat5 where list = [0..]
instance Listable Nat6 where list = [0..]
instance Listable Nat7 where list = [0..]

type UInt1 = Word1
type UInt2 = Word2
type UInt3 = Word3
type UInt4 = Word4
