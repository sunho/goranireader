
from pyspark.sql.functions import udf
from pyspark.sql.types import *
import pyspark.sql.functions as F

from datetime import timedelta, tzinfo
from dateutil.parser import parse
import datetime
import time

ZERO = timedelta(0)

class UTC(tzinfo):
    """UTC"""

    def utcoffset(self, dt):
        return ZERO

    def tzname(self, dt):
        return "UTC"

    def dst(self, dt):
        return ZERO

utc = UTC()

class Zone(tzinfo):
    def __init__(self,offset,isdst,name):
        self.offset = offset
        self.isdst = isdst
        self.name = name
    def utcoffset(self, dt):
        return timedelta(hours=self.offset) + self.dst(dt)
    def dst(self, dt):
            return timedelta(hours=1) if self.isdst else timedelta(0)
    def tzname(self,dt):
         return self.name
        
kst = Zone(9, False, "KST")

def to_timestamp(x):
    return int(time.mktime(x.timetuple()))

@udf(LongType())
def parse_ts(s):
  return to_timestamp(parse(str(s)))

@udf(StringType())
def parse_date(s):
  return datetime.datetime.fromtimestamp(s).strftime('%m/%d')

