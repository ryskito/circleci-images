BUNDLES = \
  android node python ruby golang php \
  postgres mariadb mysql mongo elixir \
  jruby clojure openjdk buildpack-deps

images: $(foreach b, $(BUNDLES), $(b)/generate_images)

example_images: $(foreach b, $(BUNDLES), $(b)/example_image)

%/example_image:
	cd $(@D) && find . -name Dockerfile -type f | head -1 | xargs -I{} cp /Users/avena/Desktop/example-images/$(@D) && find . -name README.md -type f | head -1 | xargs -I{} cp /Users/avena/Desktop/example-images/$(@D)

publish_images: images
	find . -name Dockerfile | awk '{ print length, $0 }' | sort -n -s | cut -d" " -f2- | sed 's|/Dockerfile|/publish_image|g' | xargs -n1 make

%/generate_images:
	cd $(@D) && ./generate-images

%/publish_images: %/generate_images
	find ./$(@D) -name Dockerfile | awk '{ print length, $$0 }' | sort -n -s | cut -d" " -f2- | sed 's|/Dockerfile|/publish_image|g' | xargs -n1 make

%/publish_image: %/Dockerfile
	./shared/images/build.sh ./$(@D)/Dockerfile

%/clean:
	cd $(@D) ; rm -r images || true

clean: $(foreach b, $(BUNDLES), $(b)/clean)