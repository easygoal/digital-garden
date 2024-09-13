build:
	bundle exec jekyll build

exec:
	docker exec -it hexo /bin/sh

image:
	docker build . -t hexo_test

