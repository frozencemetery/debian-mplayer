--- a/Makefile
+++ b/Makefile
@@ -987,6 +987,7 @@ distclean: clean testsclean toolsclean d
 	-rm -f config.log config.mak config.h codecs.conf.h help_mp.h \
            version.h $(VIDIX_PCI_FILES) TAGS tags
 	-rm -f $(call ADD_ALL_EXESUFS,codec-cfg cpuinfo)
+	-rm -f libavutil/avconfig.h
 
 doxygen:
 	doxygen DOCS/tech/Doxyfile
