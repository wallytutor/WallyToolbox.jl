side = 0.01;
h = side * Sqrt(3)/2;

x1 = 0.05 - 1*side/2;
x2 = 0.05 - 0*side/2;
x3 = 0.05 + 1*side/2;

y1 = 0.050;
y2 = y1 + h;
y3 = 0.25;
y4 = y3 - h;

View "background mesh" {
    ST(x1, y1, 0,
       x2, y2, 0,
       x3, y1, 0){
        0.010,
        0.002,
        0.050
    };
    ST(x1, y3, 0,
       x2, y4, 0,
       x3, y3, 0){
        0.002,
        0.005,
        0.003
     };
    //  ST(x1, 0.15, 0,
    //     x2, 0.12, 0,
    //     x3, 0.16, 0){
    //      0.002,
    //      0.003,
    //      0.003
    //   };
};