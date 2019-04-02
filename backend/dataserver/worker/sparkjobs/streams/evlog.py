from worker.shared import FinalStreamJob, StreamJobContext
from worker.shared.schema import UserEventLogSchema
from pyspark.sql.functions import from_json, lit
from pyspark.sql import DataFrame
from pyspark.sql.types import StructType
from worker.shared.utils import binary_to_string, uuid
from .user_evlog_trasforms import factory

class StreamEvlogJob(FinalStreamJob):
    def __init__(self, context: StreamJobContext):
        FinalStreamJob.__init__(self, context, 'Stream Event Log', ['user_evlog', 'system_evlog'])

    def start(self):
        user_df = self.get_stream('user', UserEventLogSchema)
        user_transforms = factory(self.context)
        for transform in user_transforms:
            user_df + transform

    def get_stream(self, name: str, schema: StructType) -> DataFrame:
        df = self.context.stream.where('topic = "{}_evlog"'.format(name))
        df = binary_to_string('value', df)\
            .withColumn('value', from_json('value', schema))\
            .select('value.*')

        self.write_data_stream('{}_event_logs'.format(name), df.withColumn('id', uuid()))\
            .trigger(processingTime='5 seconds')\
            .start()

        return df
