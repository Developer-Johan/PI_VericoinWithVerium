# Copyright (c) 2009-2010 Satoshi Nakamoto
# Distributed under the MIT/X11 software license, see the accompanying
# file COPYING or http://www.opensource.org/licenses/mit-license.php.

USE_UPNP:=1
USE_IPV6:=1
USE_AVX:=1
USE_AVX2:=0


LINK:=$(CXX)
ARCH:=$(shell uname -m)

DEFS=-DBOOST_SPIRIT_THREADSAFE -D__STDC_FORMAT_MACROS -D__STDC_LIMIT_MACROS

DEFS += $(addprefix -I,$(CURDIR) $(CURDIR)/obj $(BOOST_INCLUDE_PATH) $(BDB_INCLUDE_PATH) $(OPENSSL_INCLUDE_PATH))
LIBS = $(addprefix -L,$(BOOST_LIB_PATH) $(BDB_LIB_PATH) $(OPENSSL_LIB_PATH))

LMODE = dynamic
LMODE2 = dynamic
ifdef STATIC
	LMODE = static
	ifeq (${STATIC}, all)
		LMODE2 = static
	endif
endif

# for boost 1.37, add -mt to the boost libraries
LIBS += \
 -Wl,-B$(LMODE) \
   -l boost_system$(BOOST_LIB_SUFFIX) \
   -l boost_filesystem$(BOOST_LIB_SUFFIX) \
   -l boost_program_options$(BOOST_LIB_SUFFIX) \
   -l boost_thread$(BOOST_LIB_SUFFIX) \
   -l db_cxx$(BDB_LIB_SUFFIX) \
   -l ssl \
   -l crypto \
   -l curl \
   -l minizip

ifndef USE_UPNP
	override USE_UPNP = -
endif
ifneq (${USE_UPNP}, -)
	LIBS += -l miniupnpc
	DEFS += -DUSE_UPNP=$(USE_UPNP)
endif

ifneq (${USE_IPV6}, -)
	DEFS += -DUSE_IPV6=$(USE_IPV6)
endif
ifeq (${USE_AVX}, 1)
	DEFS += -DUSE_AVX
endif
ifeq (${USE_AVX2}, 1)
	DEFS += -DUSE_AVX2
endif


LIBS+= \
 -Wl,-B$(LMODE2) \
   -l z \
   -l dl \
   -l pthread


# Hardening
# Make some classes of vulnerabilities unexploitable in case one is discovered.
#
    # This is a workaround for Ubuntu bug #691722, the default -fstack-protector causes
    # -fstack-protector-all to be ignored unless -fno-stack-protector is used first.
    # see: https://bugs.launchpad.net/ubuntu/+source/gcc-4.5/+bug/691722
    HARDENING=-fno-stack-protector

    # Stack Canaries
    # Put numbers at the beginning of each stack frame and check that they are the same.
    # If a stack buffer if overflowed, it writes over the canary number and then on return
    # when that number is checked, it won't be the same and the program will exit with
    # a "Stack smashing detected" error instead of being exploited.
    HARDENING+=-fstack-protector-all -Wstack-protector

    # Make some important things such as the global offset table read only as soon as
    # the dynamic linker is finished building it. This will prevent overwriting of addresses
    # which would later be jumped to.
    LDHARDENING+=-Wl,-z,relro -Wl,-z,now

    # Build position independent code to take advantage of Address Space Layout Randomization
    # offered by some kernels.
    # see doc/build-unix.txt for more information.
    ifdef PIE
        HARDENING+=-fPIE
        LDHARDENING+=-pie
    endif

    # -D_FORTIFY_SOURCE=2 does some checking for potentially exploitable code patterns in
    # the source such overflowing a statically defined buffer.
    HARDENING+=-D_FORTIFY_SOURCE=2
#


DEBUGFLAGS=-g


ifeq (${ARCH}, i686)
    EXT_OPTIONS=-msse2
endif


# CXXFLAGS can be specified on the make command line, so we use xCXXFLAGS that only
# adds some defaults in front. Unfortunately, CXXFLAGS=... $(CXXFLAGS) does not work.
xCXXFLAGS=-O2 $(EXT_OPTIONS) -pthread -Wall -Wextra -Wno-ignored-qualifiers -Wformat -Wformat-security -Wno-unused-parameter \
    $(DEBUGFLAGS) $(DEFS) $(HARDENING) $(CXXFLAGS)

# LDFLAGS can be specified on the make command line, so we use xLDFLAGS that only
# adds some defaults in front. Unfortunately, LDFLAGS=... $(LDFLAGS) does not work.
xLDFLAGS=$(LDHARDENING) $(LDFLAGS)

OBJS= \
    obj/alert.o \
    obj/version.o \
    obj/checkpoints.o \
    obj/netbase.o \
    obj/addrman.o \
    obj/crypter.o \
    obj/key.o \
    obj/db.o \
    obj/init.o \
    obj/irc.o \
    obj/keystore.o \
    obj/miner.o \
    obj/main.o \
    obj/net.o \
    obj/protocol.o \
    obj/bitcoinrpc.o \
    obj/rpcdump.o \
    obj/rpcnet.o \
    obj/rpcmining.o \
    obj/rpcwallet.o \
    obj/rpcblockchain.o \
    obj/rpcrawtransaction.o \
    obj/script.o \
    obj/sync.o \
    obj/util.o \
    obj/wallet.o \
    obj/walletdb.o \
    obj/noui.o \
    obj/scrypt.o \
    obj/miniunz.o

all: veriumd

LIBS += $(CURDIR)/leveldb/libleveldb.a $(CURDIR)/leveldb/libmemenv.a
DEFS += $(addprefix -I,$(CURDIR)/leveldb/include)
DEFS += $(addprefix -I,$(CURDIR)/leveldb/helpers)
OBJS += obj/txdb-leveldb.o
leveldb/libleveldb.a:
	@echo "Building LevelDB ..."; cd leveldb; make libleveldb.a libmemenv.a; cd ..;
obj/txdb-leveldb.o: leveldb/libleveldb.a

# Assembler implementation
DEFS += -DUSE_ASM

OBJS += obj/scrypt-arm.o obj/scrypt-x86.o obj/scrypt-x64.o

obj/scrypt-x86.o: scrypt-x86.S
	$(CXX) -c $(CFLAGS) -MMD -o $@ $<

obj/scrypt-x64.o: scrypt-x64.S
	$(CXX) -c $(CFLAGS) -MMD -o $@ $<

obj/scrypt-arm.o: scrypt-arm.S
	$(CXX) -c $(CFLAGS) -MMD -o $@ $<

OBJS += obj/sha2-arm.o obj/sha2-x86.o obj/sha2-x64.o

obj/sha2-x86.o: sha2-x86.S
	$(CXX) -c $(CFLAGS) -MMD -o $@ $<

obj/sha2-x64.o: sha2-x64.S
	$(CXX) -c $(CFLAGS) -MMD -o $@ $<

obj/sha2-arm.o: sha2-arm.S
	$(CXX) -c $(CFLAGS) -MMD -o $@ $<


ifeq (${ARCH}, aarch644)

obj/sha2-armv8.o: sha2-armv8.c
	$(CC) -c $(CFLAGS) -march=armv8.1-a+crypto -MMD -o $@ $<

obj/scrypt-armv8.o: scrypt-armv8.c
	$(CC) -c $(CFLAGS) -march=armv8.1-a+crypto -MMD -o $@ $<

OBJS += obj/sha2-armv8.o obj/scrypt-armv8.o

endif


# auto-generated dependencies:
-include obj/*.P

obj/build.h: FORCE
	/bin/sh ../share/genbuild.sh obj/build.h
version.cpp: obj/build.h
DEFS += -DHAVE_BUILD_INFO

obj/%.o: %.cpp
	$(CXX) -c $(xCXXFLAGS) -MMD -MF $(@:%.o=%.d) -o $@ $<
	@cp $(@:%.o=%.d) $(@:%.o=%.P); \
	  sed -e 's/#.*//' -e 's/^[^:]*: *//' -e 's/ *\\$$//' \
	      -e '/^$$/ d' -e 's/$$/ :/' < $(@:%.o=%.d) >> $(@:%.o=%.P); \
	  rm -f $(@:%.o=%.d)

veriumd: $(OBJS:obj/%=obj/%)
	$(LINK) $(xCXXFLAGS) -o $@ $^ $(xLDFLAGS) $(LIBS)

clean:
	-rm -f veriumd
	-rm -f obj/*.o
	-rm -f obj/*.P
	-rm -f obj/*.d
	-rm -f obj/build.h
	cd leveldb; make clean; cd ..;

FORCE: