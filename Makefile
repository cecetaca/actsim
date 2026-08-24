#-------------------------------------------------------------------------
#
#  Copyright (c) 2020 Rajit Manohar
#
#  This program is free software; you can redistribute it and/or
#  modify it under the terms of the GNU General Public License
#  as published by the Free Software Foundation; either version 2
#  of the License, or (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor,
#  Boston, MA  02110-1301, USA.
#
#-------------------------------------------------------------------------
EXE=actsim.$(EXT)

SUBDIRS=simlib
TARGETS=$(EXE)
LIB1=libactsim_$(EXT).a
TARGETLIBS=$(LIB1)
TARGETINCS=actsim_ext.h actsim.h state.h channel.h chpsim.h prssim.h xycesim.h
TARGETINCSUBDIR=act

OBJS=actsim.o core.o main.o \
	constraints.o \
	chpsim.o chpgraph.o prssim.o state.o channel.o xycesim.o


SRCS=$(OBJS:.o=.cc)

include config.mk

ifdef N_CIR_XyceCInterface_INCLUDE
include xyce.in
endif

include $(ACT_HOME)/scripts/Makefile.std

$(EXE): $(OBJS) $(ACTPASSDEPEND) $(ACT_HOME)/lib/libtracelib.a
	$(CXX) $(SH_EXE_OPTIONS) $(CFLAGS) $(OBJS) -o $(EXE) -lactannotate $(LIBACTPASS) $(LIBASIM) $(LIBACTSCMCLI) -ltracelib -lm -ldl -ledit $(LIBXYCE) -lz

# simulator core as a static library for embedding (everything except the CLI);
# consumers must provide glob_sim, debug_metrics, actsim_Act(), actsim_top(),
# and is_rand_excl(), which are otherwise defined in main.cc
LIBOBJS=$(filter-out main.o,$(OBJS))

$(LIB1): $(LIBOBJS)
	ar ruv $(LIB1) $(LIBOBJS)
	$(RANLIB) $(LIB1)

-include Makefile.deps
