build:
	bundle exec jekyll build

exec:
	docker exec -it hexo /bin/sh

image:
	docker build . -t hexo_test

docker:
	docker exec hexo sh -c "make -C digital-garden"

check:
	find . -name ".hist" | xargs ls

