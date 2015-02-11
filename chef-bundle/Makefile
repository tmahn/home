binstubs: bundle binstub.in
	rm -rf bin
	mkdir -p bin
	for F in \
		vendor/bundle/ruby/2.0.0/gems/*/bin/chef* \
		vendor/bundle/ruby/2.0.0/gems/*/bin/knife* \
		; \
	do \
	    PROG="$${F##*/}"; \
	    GEM="$${F#*/gems/}"; \
	    GEM="$${GEM%/bin/*}"; \
	    GEM="$${GEM%-[0-9.]*}"; \
	    sed -e s/@GEM@/$$GEM/g \
		-e s/@PROG@/$$PROG/g \
		< binstub.in > "bin/$${PROG}"; \
	    chmod +x "bin/$${PROG}"; \
	done
	touch $@

bundle: Gemfile
	$(MAKE) clean
	bundle install --local
	bundle install --deployment
	GEM_HOME=vendor/bundle/ruby/2.0.0 \
	    gem install bundler --no-user-install --no-ri --no-rdoc
	touch $@

clean:
	rm -rf bundle binstubs
	rm -f Gemfile.lock
	rm -rf .bundle
	rm -rf vendor
	rm -rf bin
