
algorithm alg1(
  input  uint1  c,
  output uint1  b  // DEFAULT VALUE!!!!!
) <autorun> {

  uint1 tmp_c = 0;

  while (1) {
  $display("[1] b=%d c=%d",b,c);
    if (tmp_c == 1) {
      b = 1;
    }
  }

  tmp_c := c;
   
}

algorithm alg2(
  input  uint1  b,
  output uint1  c
) <autorun> {

  uint1 tmp_b = 0;
  
  while (1) {
  $display("[2] b=%d c=%d",b,c);
    if (tmp_b == 0) {
      c = 1;
    }
  }

  tmp_b := b;
  
}

algorithm main( ) {

uint1  b = 1; // errr, this is totally ignored, right? becomes a wire (output of a1)
uint1  c = 0; 
uint8  i = 0;

alg1 a1(
  b :> b,
  c <: c
);

alg2 a2(
  b <: b,
  c :> c
);

while (i < 16) {
  i = i + 1;
}

}
