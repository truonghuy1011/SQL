CREATE LOGIN tk01 WITH PASSWORD = '0123456',

DEFAULT_DATABASE = qltv
CREATE LOGIN tk02 WITH PASSWORD = '0123456',

DEFAULT_DATABASE = qltv
CREATE LOGIN tk03 WITH PASSWORD = '0123456',

DEFAULT_DATABASE = qltv
CREATE LOGIN tk04 WITH PASSWORD = '0123456',

DEFAULT_DATABASE = qltv
CREATE LOGIN tk05 WITH PASSWORD = '0123456',

DEFAULT_DATABASE = qltv
CREATE LOGIN tk06 WITH PASSWORD = '0123456',

DEFAULT_DATABASE = qltv
CREATE LOGIN tk07 WITH PASSWORD = '0123456',

DEFAULT_DATABASE = qltv
CREATE LOGIN tk08 WITH PASSWORD = '0123456',

DEFAULT_DATABASE = qltv
CREATE LOGIN tk09 WITH PASSWORD = '0123456',

DEFAULT_DATABASE = qltv
CREATE LOGIN tk10 WITH PASSWORD = '0123456',

DEFAULT_DATABASE = qltv

use qltv
CREATE USER dinhhoangvu
FROM LOGIN tk01

CREATE USER vanthinganha
FROM LOGIN tk02

CREATE USER nguyendinhhoang
FROM LOGIN tk03

CREATE USER nguyenvansu
FROM LOGIN tk04

CREATE USER lequangvu
FROM LOGIN tk05

CREATE USER buiminhtuan
FROM LOGIN tk06

CREATE USER nguyenthithutrang
FROM LOGIN tk07

CREATE USER trananhvu
FROM LOGIN tk08

CREATE USER nguyendaitruong
FROM LOGIN tk09

CREATE USER nguyenvietvu
FROM LOGIN tk10

CREATE ROLE docgia
GRANT select on DOCGIA
to docgia
GRANT select on nguoilon
to docgia
GRANT select on treem
to docgia
GRANT select on tuasach
to docgia
GRANT select on dausach
to docgia
GRANT select on cuonsach
to docgia
GRANT select on muon
to docgia


CREATE ROLE thuthu
GRANT select, insert, update 
to thuthu

CREATE ROLE quanly AUTHORIZATION db_backupoperator
GRANT select, insert
to quanly


CREATE ROLE giamdoc AUTHORIZATION db_owner

alter role docgia add member dinhhoangvu
alter role docgia add member nguyenvansu
alter role giamdoc add member vanthinganha
alter role quanly add member nguyenvietvu
alter role docgia add member lequangvu
alter role thuthu add member buiminhtuan
alter role docgia add member nguyenthithutrang
alter role giamdoc add member trananhvu
alter role thuthu add member nguyendaitruong
alter role quanly add member nguyendinhhoang