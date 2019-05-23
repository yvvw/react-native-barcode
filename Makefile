LIB_ICONV := libiconv-1.16
LIB_ZBAR := ZBar

NDK_BUILD_ENV := \
	NDK_PROJECT_PATH=$(PWD)/android_zbar \
	NDK_LIBS_OUT=$(PWD)/android/src/main/jniLibs \
	NDK_OUT=$(PWD)/build \
	ICONV_SRC=$(PWD)/third_party/$(LIB_ICONV) \
	ZBAR_SRC=$(PWD)/third_party/$(LIB_ZBAR)

.PHONY: android
android: third_party/$(LIB_ZBAR) third_party/$(LIB_ICONV)
	@$(NDK_BUILD_ENV) $(ANDROID_HOME)/ndk-bundle/ndk-build && \
	cp -a $(PWD)/third_party/$(LIB_ZBAR)/java/net \
		$(PWD)/android/src/main/java

.PHONY: clean
clean:
	@$(NDK_BUILD_ENV) $(ANDROID_HOME)/ndk-bundle/ndk-build clean && \
	rm -r $(PWD)/third_party/$(LIB_ICONV) \
		$(PWD)/android/src/main/jniLibs \
		$(PWD)/android/src/main/java/net

third_party/$(LIB_ZBAR):
	@git submodule update --init $@

third_party/$(LIB_ICONV):
	@cd third_party && \
	curl -O https://ftp.gnu.org/pub/gnu/libiconv/$(LIB_ICONV).tar.gz && \
	tar -zxvf $(LIB_ICONV).tar.gz && \
	rm $(LIB_ICONV).tar.gz && \
	cd $(LIB_ICONV) && ./configure
