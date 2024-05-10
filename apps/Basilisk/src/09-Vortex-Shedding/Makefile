CODENAME := model
QCCOPTS  := -O2 -Wall
RESULTS  := *.csv *.ppm *.gif *.png *.mp4 perfs

STATICS  := \
	$(BASILISK)/gl/libfb_tiny.a \
	$(BASILISK)/gl/libglutils.a

all: $(CODENAME) 
	./$(CODENAME)

$(CODENAME): app.c
	qcc $(QCCOPTS) app.c $(STATICS) -o $(CODENAME) -lm

clean:
	rm -rf $(CODENAME) $(RESULTS)

