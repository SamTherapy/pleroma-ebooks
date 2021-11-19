FROM python:3-alpine

WORKDIR /ebooks/
VOLUME /ebooks/data/ /ebooks/generators/ /ebooks/third_party/

ADD ./requirements/*.txt /ebooks/
ADD *.py /ebooks/
ADD ./generators/markov.py /ebooks/generators/
ADD ./third_party/utils.py /ebooks/third_party/
ADD config.json /ebooks/
ADD toots.db /ebooks/

RUN apk add --virtual .build-deps gcc musl-dev libffi-dev openssl-dev \
 && pip install -r .gpt2.txt -r base.txt -r markov.txt \
 && apk del --purge .build-deps

RUN (echo "*/5 * * * * cd /ebooks/ && python gen.py"; echo "5 */2 * * * cd /ebooks/ && python main.py") | crontab - 

ENV ebooks_site="https://freecumextremist.com"

CMD (test -f data/config.json || echo "{\"site\":\"${ebooks_site}\"}" > data/config.json) \
 && (test -f data/toots.db || (python main.py && exit))

CMD ["crond", "-f", "L", "/dev/stdout"]
