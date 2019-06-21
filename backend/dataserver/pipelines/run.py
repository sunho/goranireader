from string import Template
import os
def run(notebook, args):
    jupyter = open('template.yaml','r').read()
    tmpl = Template(open(notebook+'.yaml','r').read())
    with open('/tmp/run.yaml', 'w') as f:
        f.write(tmpl.substitute(jupyter=jupyter))
    txt = ' '.join(['-p {}={}'.format(key,value) for key,value in args.items()])
    os.system('argo submit {} {}'.format('/tmp/run.yaml', txt))

from PyInquirer import prompt
answers = prompt([
      {
        'type': 'list',
        'name': 'pipeline',
        'message': '어떤 작업을 실행할까요?',
        'choices': [
            '책 추천 및 답변자 매칭',
            '책 생성하기',
            '책 군집화'
            '페이지-시간 모델 훈련',
        ]
    }
])
if answers['pipeline'] == '책 추천 및 답변자 매칭':
    run('update', dict())
elif answers['pipeline'] == '페이지-시간 모델 훈련':
    pass
elif answers['pipeline'] == '책 생성하기':
    answers = prompt([
      {
        'type': 'input',
        'name': 'url',
        'message': '책의 s3주소를 입력해주세요.'
      },
      {
        'type': 'input',
        'name': 'id',
        'message': '책의 id를 입력해주세요.'
      }
    ])
    run('create-book', {'url':answers['url'], 'id':answers['id']})

elif answers['pipeline'] == '책 군집화':
    answers = prompt([
      {
        'type': 'input',
        'name': 'k',
        'message': '군집의 개수를 입력해주세요.'
      }])
    run('cluster-books', {'k': answers['k']})