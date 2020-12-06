.. Gorani Reader documentation master file, created by
   sphinx-quickstart on Tue Apr 21 11:31:36 2020.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Welcome to Gorani Reader's documentation!
=========================================

.. toctree::
   :maxdepth: 2
   :caption: Contents:

Data processing
===================

Overview
#######

DAG 모듈은 주기적으로 돌아가는 전처리나 머신러닝 모델 훈련 및 검증 작업을 담고 있습니다.

DAG 작업을 실행한 이후 나오는 결과물이 Attributes에 기술되어 있습니다.

이 결과물들은 주피터 노트북이나 파이썬 코드를 통해 바로 가져오실 수 있습니다.
예를 들어 :obj:`dataserver.dag.PreprocessPaginate` 를 실행시킨 뒤 전처리된 페이지 데이터 프레임을 아래와 같이 가져올 수 있습니다::

   from metaflow import Flow
   flow = Flow('PreprocessPaginate').latest_successful_run
   pages_df = flow.data.pages_df
   print(pages_df['userId'].unique()) # 페이지를 넘긴 유저의 아이디
Job 모듈은 실질적인 데이터 처리를 담당하는 함수들을 담고 있습니다.

DAG 모듈은 Job색션의 함수를 사용해서 데이터 처리를 합니다.

DataFrames 모듈은 DAG작업의 결과물 스키마를 담고있습니다.

DAG Pipeline
#######
작업 앞에 붙은 숫자는 우선순위 입니다. Stage1 -> Stage 2 -> Stage 3 순으로 실행됩니다.

Stage 1 (전처리)
********
1. :obj:`Download<dataserver.dag.Download>` (데이터를 불러옵니다.)

2. :obj:`PreprocessPaginates<dataserver.dag.PreprocessPaginates>` (페이지 전처리)

3. :obj:`PrepareFeatures<dataserver.dag.PrepareFeatures>` (데이터를 머신러닝 모델이 읽을 수 있는 형태로 변환)

Stage 2 (계산)
********
1. :obj:`PredictVocab<dataserver.dag.PredictVocab>` (머신러닝 모델로 유저가 모를만한 단어와 알만한 단어를 예측)

1. :obj:`GenerateStats<dataserver.dag.GenerateStats>` (통계 생성)

Stage 3 (배포)
*********
1. :obj:`GenerateReview<dataserver.dag.GenerateReview>` (리뷰 게임 생성)

DAG
########
.. automodule:: dataserver.dag
   :members:

DataFrames
########
.. automodule:: dataserver.models.dataframe
   :members:

Job
########
.. automodule:: dataserver.job
   :members:
