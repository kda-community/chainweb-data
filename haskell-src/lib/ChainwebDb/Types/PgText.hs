{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE ImpredicativeTypes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE TypeFamilies #-}

module ChainwebDb.Types.PgText where

----------------------------------------------------------------------------
import BasePrelude
import qualified Data.Text as T
import Database.Beam
import Database.Beam.Backend.SQL
import Database.Beam.Postgres
import Database.Beam.Postgres.Syntax
import Database.PostgreSQL.Simple.ToField
import Database.PostgreSQL.Simple.FromField
------------------------------------------------------------------------------
newtype PgText = PgText { unPgText :: T.Text }
  deriving newtype
    ( Eq, Ord, Show, IsString, Semigroup, Monoid, ToField, FromField
    , FromBackendRow Postgres, HasSqlEqualityCheck Postgres
    , BeamSqlBackendIsString Postgres
    )

instance HasSqlValueSyntax PgValueSyntax PgText where
  sqlValueSyntax (PgText t) = sqlValueSyntax $ escapeUnicode0 t
    where
    escapeUnicode0 :: T.Text -> T.Text
    escapeUnicode0 = T.replace "\NUL" "\\u0000"


