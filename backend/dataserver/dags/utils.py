def spark_job(args):
    return 'cd $GORANI_HOME && deploy/local/spark.sh {}'.format(args)
