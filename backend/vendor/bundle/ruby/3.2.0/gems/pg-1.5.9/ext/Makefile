
SHELL = /bin/sh

# V=0 quiet, V=1 verbose.  other values don't work.
V = 0
V0 = $(V:0=)
Q1 = $(V:1=)
Q = $(Q1:0=@)
ECHO1 = $(V:1=@ :)
ECHO = $(ECHO1:0=@ echo)
NULLCMD = :

#### Start of system configuration section. ####

srcdir = .
topdir = /usr/include
hdrdir = $(topdir)
arch_hdrdir = /usr/include
PATH_SEPARATOR = :
VPATH = $(srcdir):$(arch_hdrdir)/ruby:$(hdrdir)/ruby
prefix = $(DESTDIR)/usr
rubysitearchprefix = $(sitearchlibdir)/$(RUBY_BASE_NAME)
rubyarchprefix = $(DESTDIR)/usr/lib64/ruby3.2
rubylibprefix = $(exec_prefix)/share/ruby3.2
exec_prefix = $(DESTDIR)/usr
vendorarchhdrdir = $(vendorhdrdir)/$(arch)
sitearchhdrdir = $(sitehdrdir)/$(arch)
rubyarchhdrdir = $(DESTDIR)/usr/include
vendorhdrdir = $(rubyhdrdir)/vendor_ruby
sitehdrdir = $(rubyhdrdir)/site_ruby
rubyhdrdir = $(DESTDIR)/usr/include
rubygemsdir = $(DESTDIR)/usr/share/ruby3.2-rubygems
vendorarchdir = $(DESTDIR)/usr/lib64/ruby3.2/vendor_ruby
vendorlibdir = $(vendordir)
vendordir = $(DESTDIR)/usr/share/ruby3.2/vendor_ruby
sitearchdir = $(DESTDIR)/usr/local/lib64/ruby3.2/site_ruby
sitelibdir = $(sitedir)
sitedir = $(DESTDIR)/usr/local/share/ruby3.2/site_ruby
rubyarchdir = $(rubyarchprefix)
rubylibdir = $(rubylibprefix)
sitearchincludedir = $(includedir)/$(sitearch)
archincludedir = $(includedir)/$(arch)
sitearchlibdir = $(libdir)/$(sitearch)
archlibdir = $(DESTDIR)/usr/lib64
ridir = $(DESTDIR)/usr/share/ri/ruby3.2
mandir = $(DESTDIR)/usr/share/man
localedir = $(datarootdir)/locale
libdir = $(exec_prefix)/lib64
psdir = $(docdir)
pdfdir = $(docdir)
dvidir = $(docdir)
htmldir = $(docdir)
infodir = $(DESTDIR)/usr/share/info
docdir = $(datarootdir)/doc/$(PACKAGE)
oldincludedir = $(DESTDIR)/usr/include
includedir = $(exec_prefix)/include
runstatedir = $(localstatedir)/run
localstatedir = $(DESTDIR)/var
sharedstatedir = $(DESTDIR)/var/lib
sysconfdir = $(DESTDIR)/etc
datadir = $(DESTDIR)/usr/share
datarootdir = $(prefix)/share
libexecdir = $(DESTDIR)/usr/libexec
sbindir = $(DESTDIR)/usr/sbin
bindir = $(exec_prefix)/bin
archdir = $(rubyarchdir)


CC_WRAPPER = 
CC = gcc
CXX = g++
LIBRUBY = $(LIBRUBY_SO)
LIBRUBY_A = lib$(RUBY_SO_NAME)-static.a
LIBRUBYARG_SHARED = -l$(RUBY_SO_NAME)
LIBRUBYARG_STATIC = -l$(RUBY_SO_NAME)-static $(MAINLIBS)
empty =
OUTFLAG = -o $(empty)
COUTFLAG = -o $(empty)
CSRCFLAG = $(empty)

RUBY_EXTCONF_H = extconf.h
cflags   = $(optflags) $(debugflags) $(warnflags)
cxxflags = 
optflags = -O3 -fno-fast-math
debugflags = -ggdb3
warnflags = -Wall -Wextra -Wdeprecated-declarations -Wdiv-by-zero -Wduplicated-cond -Wimplicit-function-declaration -Wimplicit-int -Wmisleading-indentation -Wpointer-arith -Wwrite-strings -Wold-style-definition -Wimplicit-fallthrough=0 -Wmissing-noreturn -Wno-cast-function-type -Wno-constant-logical-operand -Wno-long-long -Wno-missing-field-initializers -Wno-overlength-strings -Wno-packed-bitfield-compat -Wno-parentheses-equality -Wno-self-assign -Wno-tautological-compare -Wno-unused-parameter -Wno-unused-value -Wsuggest-attribute=format -Wsuggest-attribute=noreturn -Wunused-variable -Wundef
cppflags = 
CCDLFLAGS = -fPIC
CFLAGS   = $(CCDLFLAGS) -O2 -ftree-vectorize -flto=auto -ffat-lto-objects -fexceptions -g -grecord-gcc-switches -pipe -Wall -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -Wp,-D_GLIBCXX_ASSERTIONS -specs=/usr/lib/rpm/redhat/redhat-hardened-cc1 -fstack-protector-strong -specs=/usr/lib/rpm/redhat/redhat-annobin-cc1 -march=x86-64-v2 -mtune=generic -fasynchronous-unwind-tables -fstack-clash-protection -fcf-protection -fPIC $(ARCH_FLAG)
INCFLAGS = -I. -I$(arch_hdrdir) -I$(hdrdir)/ruby/backward -I$(hdrdir) -I$(srcdir)
DEFS     = 
CPPFLAGS = -DRUBY_EXTCONF_H=\"$(RUBY_EXTCONF_H)\" -I/usr/include  $(DEFS) $(cppflags)
CXXFLAGS = $(CCDLFLAGS) -O2 -ftree-vectorize -flto=auto -ffat-lto-objects -fexceptions -g -grecord-gcc-switches -pipe -Wall -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -Wp,-D_GLIBCXX_ASSERTIONS -specs=/usr/lib/rpm/redhat/redhat-hardened-cc1 -fstack-protector-strong -specs=/usr/lib/rpm/redhat/redhat-annobin-cc1 -march=x86-64-v2 -mtune=generic -fasynchronous-unwind-tables -fstack-clash-protection -fcf-protection $(ARCH_FLAG)
ldflags  = -L. -Wl,-z,relro -Wl,--as-needed  -Wl,-z,now -specs=/usr/lib/rpm/redhat/redhat-hardened-ld -specs=/usr/lib/rpm/redhat/redhat-annobin-cc1  -Wl,--build-id=sha1 -fstack-protector-strong -rdynamic -Wl,-export-dynamic -Wl,--no-as-needed -Wl,-rpath,/usr/lib64
dldflags = -Wl,-z,relro -Wl,--as-needed  -Wl,-z,now -specs=/usr/lib/rpm/redhat/redhat-hardened-ld -specs=/usr/lib/rpm/redhat/redhat-annobin-cc1  -Wl,--build-id=sha1  
ARCH_FLAG = -m64
DLDFLAGS = $(ldflags) $(dldflags) $(ARCH_FLAG)
LDSHARED = $(CC) -shared
LDSHAREDXX = $(CXX) -shared
AR = gcc-ar
EXEEXT = 

RUBY_INSTALL_NAME = $(RUBY_BASE_NAME)3.2
RUBY_SO_NAME = ruby
RUBYW_INSTALL_NAME = 
RUBY_VERSION_NAME = $(RUBY_BASE_NAME)-$(ruby_version_dir_name)
RUBYW_BASE_NAME = rubyw
RUBY_BASE_NAME = ruby

arch = x86_64-linux
sitearch = $(arch)
ruby_version = 3.2.0
ruby = $(bindir)/$(RUBY_BASE_NAME)3.2
RUBY = $(ruby)
BUILTRUBY = $(bindir)/$(RUBY_BASE_NAME)3.2
ruby_headers = $(hdrdir)/ruby.h $(hdrdir)/ruby/backward.h $(hdrdir)/ruby/ruby.h $(hdrdir)/ruby/defines.h $(hdrdir)/ruby/missing.h $(hdrdir)/ruby/intern.h $(hdrdir)/ruby/st.h $(hdrdir)/ruby/subst.h $(arch_hdrdir)/ruby/config.h $(RUBY_EXTCONF_H)

RM = rm -f
RM_RF = rm -fr
RMDIRS = rmdir --ignore-fail-on-non-empty -p
MAKEDIRS = /usr/bin/mkdir -p
INSTALL = /usr/bin/install -c
INSTALL_PROG = $(INSTALL) -m 0755
INSTALL_DATA = $(INSTALL) -m 644
COPY = cp
TOUCH = exit >

#### End of system configuration section. ####

preload = 
libpath = . $(archlibdir) /usr/lib64
LIBPATH =  -L. -L$(archlibdir) -L/usr/lib64
DEFFILE = 

CLEANFILES = mkmf.log
DISTCLEANFILES = 
DISTCLEANDIRS = 

extout = 
extout_prefix = 
target_prefix = 
LOCAL_LIBS = 
LIBS = $(LIBRUBYARG_SHARED) -lpq  -lm -lpthread  -lc
ORIG_SRCS = gvl_wrappers.c pg.c pg_binary_decoder.c pg_binary_encoder.c pg_coder.c pg_connection.c pg_copy_coder.c pg_errors.c pg_record_coder.c pg_result.c pg_text_decoder.c pg_text_encoder.c pg_tuple.c pg_type_map.c pg_type_map_all_strings.c pg_type_map_by_class.c pg_type_map_by_column.c pg_type_map_by_mri_type.c pg_type_map_by_oid.c pg_type_map_in_ruby.c pg_util.c
SRCS = $(ORIG_SRCS) 
OBJS = gvl_wrappers.o pg.o pg_binary_decoder.o pg_binary_encoder.o pg_coder.o pg_connection.o pg_copy_coder.o pg_errors.o pg_record_coder.o pg_result.o pg_text_decoder.o pg_text_encoder.o pg_tuple.o pg_type_map.o pg_type_map_all_strings.o pg_type_map_by_class.o pg_type_map_by_column.o pg_type_map_by_mri_type.o pg_type_map_by_oid.o pg_type_map_in_ruby.o pg_util.o
HDRS = $(srcdir)/extconf.h $(srcdir)/gvl_wrappers.h $(srcdir)/pg.h $(srcdir)/pg_util.h
LOCAL_HDRS = 
TARGET = pg_ext
TARGET_NAME = pg_ext
TARGET_ENTRY = Init_$(TARGET_NAME)
DLLIB = $(TARGET).so
EXTSTATIC = 
STATIC_LIB = 

TIMESTAMP_DIR = .
BINDIR        = $(bindir)
RUBYCOMMONDIR = $(sitedir)$(target_prefix)
RUBYLIBDIR    = $(sitelibdir)$(target_prefix)
RUBYARCHDIR   = $(sitearchdir)$(target_prefix)
HDRDIR        = $(sitehdrdir)$(target_prefix)
ARCHHDRDIR    = $(sitearchhdrdir)$(target_prefix)
TARGET_SO_DIR =
TARGET_SO     = $(TARGET_SO_DIR)$(DLLIB)
CLEANLIBS     = $(TARGET_SO) false
CLEANOBJS     = $(OBJS) *.bak
TARGET_SO_DIR_TIMESTAMP = $(TIMESTAMP_DIR)/.sitearchdir.time

all:    $(DLLIB)
static: $(STATIC_LIB)
.PHONY: all install static install-so install-rb
.PHONY: clean clean-so clean-static clean-rb

clean-static::
clean-rb-default::
clean-rb::
clean-so::
clean: clean-so clean-static clean-rb-default clean-rb
		-$(Q)$(RM_RF) $(CLEANLIBS) $(CLEANOBJS) $(CLEANFILES) .*.time

distclean-rb-default::
distclean-rb::
distclean-so::
distclean-static::
distclean: clean distclean-so distclean-static distclean-rb-default distclean-rb
		-$(Q)$(RM) Makefile $(RUBY_EXTCONF_H) conftest.* mkmf.log
		-$(Q)$(RM) core ruby$(EXEEXT) *~ $(DISTCLEANFILES)
		-$(Q)$(RMDIRS) $(DISTCLEANDIRS) 2> /dev/null || true

realclean: distclean
install: install-so install-rb

install-so: $(DLLIB) $(TARGET_SO_DIR_TIMESTAMP)
	$(INSTALL_PROG) $(DLLIB) $(RUBYARCHDIR)
clean-static::
	-$(Q)$(RM) $(STATIC_LIB)
install-rb: pre-install-rb do-install-rb install-rb-default
install-rb-default: pre-install-rb-default do-install-rb-default
pre-install-rb: Makefile
pre-install-rb-default: Makefile
do-install-rb:
do-install-rb-default:
pre-install-rb-default:
	@$(NULLCMD)
pre-install-rb: $(TIMESTAMP_DIR)/.sitelibdir.-.pg.time
do-install-rb: $(RUBYLIBDIR)/pg//postgresql_lib_path.rb
$(RUBYLIBDIR)/pg//postgresql_lib_path.rb: postgresql_lib_path.rb $(TIMESTAMP_DIR)/.sitelibdir.-.pg.time
	$(Q) $(INSTALL_DATA) postgresql_lib_path.rb $(@D)
pre-install-rb:
	$(Q1:0=@$(MAKE) -q do-install-rb || )$(ECHO1:0=echo) installing pg_ext libraries
$(TARGET_SO_DIR_TIMESTAMP):
	$(Q) $(MAKEDIRS) $(@D) $(RUBYARCHDIR)
	$(Q) $(TOUCH) $@
$(TIMESTAMP_DIR)/.sitelibdir.-.pg.time:
	$(Q) $(MAKEDIRS) $(@D) $(RUBYLIBDIR)/pg/
	$(Q) $(TOUCH) $@

site-install: site-install-so site-install-rb
site-install-so: install-so
site-install-rb: install-rb

.SUFFIXES: .c .m .cc .mm .cxx .cpp .o .S

.cc.o:
	$(ECHO) compiling $(<)
	$(Q) $(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) $(COUTFLAG)$@ -c $(CSRCFLAG)$<

.cc.S:
	$(ECHO) translating $(<)
	$(Q) $(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) $(COUTFLAG)$@ -S $(CSRCFLAG)$<

.mm.o:
	$(ECHO) compiling $(<)
	$(Q) $(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) $(COUTFLAG)$@ -c $(CSRCFLAG)$<

.mm.S:
	$(ECHO) translating $(<)
	$(Q) $(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) $(COUTFLAG)$@ -S $(CSRCFLAG)$<

.cxx.o:
	$(ECHO) compiling $(<)
	$(Q) $(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) $(COUTFLAG)$@ -c $(CSRCFLAG)$<

.cxx.S:
	$(ECHO) translating $(<)
	$(Q) $(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) $(COUTFLAG)$@ -S $(CSRCFLAG)$<

.cpp.o:
	$(ECHO) compiling $(<)
	$(Q) $(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) $(COUTFLAG)$@ -c $(CSRCFLAG)$<

.cpp.S:
	$(ECHO) translating $(<)
	$(Q) $(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) $(COUTFLAG)$@ -S $(CSRCFLAG)$<

.c.o:
	$(ECHO) compiling $(<)
	$(Q) $(CC) $(INCFLAGS) $(CPPFLAGS) $(CFLAGS) $(COUTFLAG)$@ -c $(CSRCFLAG)$<

.c.S:
	$(ECHO) translating $(<)
	$(Q) $(CC) $(INCFLAGS) $(CPPFLAGS) $(CFLAGS) $(COUTFLAG)$@ -S $(CSRCFLAG)$<

.m.o:
	$(ECHO) compiling $(<)
	$(Q) $(CC) $(INCFLAGS) $(CPPFLAGS) $(CFLAGS) $(COUTFLAG)$@ -c $(CSRCFLAG)$<

.m.S:
	$(ECHO) translating $(<)
	$(Q) $(CC) $(INCFLAGS) $(CPPFLAGS) $(CFLAGS) $(COUTFLAG)$@ -S $(CSRCFLAG)$<

$(TARGET_SO): $(OBJS) Makefile
	$(ECHO) linking shared-object $(DLLIB)
	-$(Q)$(RM) $(@)
	$(Q) $(LDSHARED) -o $@ $(OBJS) $(LIBPATH) $(DLDFLAGS) $(LOCAL_LIBS) $(LIBS)



$(OBJS): $(HDRS) $(ruby_headers)
