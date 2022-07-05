{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE RoleAnnotations #-}
{-# LANGUAGE UndecidableInstances #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE ScopedTypeVariables #-}
module SuperRecord.Variant.Tagged
    ( TaggedVariant, toTaggedVariant, fromTaggedVariant
    , taggedVariantCase
    , JsonTaggedVariant(..)
    )
where

import SuperRecord.Field
import SuperRecord.Variant

import GHC.TypeLits

-- | Just a type alias vor 'Variant'
type TaggedVariant opts = Variant opts

-- | Newtype wrapper for  'TaggedVariant' which provides a useful JSON
-- encoding of tagged variants in the form @{"tag": <value>}@
newtype JsonTaggedVariant opts
    = JsonTaggedVariant { unJsonTaggedVariant :: TaggedVariant opts }



-- | Helper function to construct a tagged variant value given the tag
-- and the value. Note that you can use OverloadedLabels for nicer syntax
-- to construct the 'FldProxy'.
--
-- > toTaggedVariant #myTag "myValue"
toTaggedVariant ::
    forall opts lbl a pos.
    ( KnownSymbol lbl, VariantMember (lbl := a) opts
    , KnownNat pos, VariantPos (lbl := a) opts ~ pos
    )
    => FldProxy lbl -> a -> TaggedVariant opts
toTaggedVariant proxy value = toVariant (proxy := value)

-- | Convert a variant back to a common Haskell type. Returns nothing
-- if the variant is not of the right tag and type.
fromTaggedVariant ::
    forall opts lbl a pos.
    ( KnownSymbol lbl, VariantMember (lbl := a) opts
    , KnownNat pos, VariantPos (lbl := a) opts ~ pos
    )
    => FldProxy lbl -> TaggedVariant opts -> Maybe a
fromTaggedVariant _ variant =
    let loader :: Maybe (lbl := a)
        loader = fromVariant variant
    in case loader of
         Just (_ := r) -> Just r
         Nothing -> Nothing

-- | Nicer syntax for 'VariantCase' for tagged variants.
taggedVariantCase ::
    forall lbl t ts r.
    FldProxy lbl -> (t -> r) -> VariantMatch r ts
    -> VariantMatch r ((lbl := t) ': ts)
taggedVariantCase _ go match =
    let f :: (lbl := t) -> r
        f (_ := x) = go x
    in VariantCase f match
{-# INLINE taggedVariantCase #-}
