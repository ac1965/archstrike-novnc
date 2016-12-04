# Docker Image Name (is taken from package.json file)
NAME = archstrike-novnc

# Image Version (is taken from package.json file)
##VERSION = $(shell cd .; git describe --long --tags --dirty --always)
VERSION = latest

# Dockerhub Image Name 
DOCKERHUB_NAME = ac1965/$(NAME):$(VERSION)

.PHONY: all check_exists check_ssh_key run run_bash clean build

all: build

# Perform a check if Docker image exists
check_exists:
	@if ! docker images $(NAME) | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME) version $(VERSION) is not yet built. Please run 'make build'"; false; fi

# Run image
run: check_exists
	docker run -dti -p 6080:6080 \
		--name $(NAME)-$(shell date +%Y%m%d) \
		$(NAME):$(VERSION)

# Used for quality diagnostics
# Opens bash session
run_bash: check_exists
	docker run -dti -p 6080:6080 \
		--name $(NAME)-$(shell date +%Y%m%d) \
		$(NAME):$(VERSION)

# Remove Docker image
clean:
	@if docker images $(NAME) | awk '{ print $$2 }' | grep -q -F $(VERSION); then docker rmi $(NAME):$(VERSION); fi

# Build Docker image
build:
	@echo "Making Image: $(NAME):$(VERSION)"
	@docker build -t $(NAME):$(VERSION) .

dockerhub_tag:
	@docker tag $(NAME):$(VERSION) $(DOCKERHUB_NAME)

dockerhub_push: check_exists dockerhub_tag
	@docker push $(DOCKERHUB_NAME)
