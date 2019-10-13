
// Text buffer
import('verilog/text_buffer.v')

// ------------------------- 

algorithm text_display(
  input  uint11 hdmi_x,
  input  uint10 hdmi_y,
  input  uint1  hdmi_active,
  output uint8  hdmi_red,
  output uint8  hdmi_green,
  output uint8  hdmi_blue
) <autorun> {

// Text buffer

uint14 txtaddr   = 0;
uint6  txtdata_r = 0;
uint6  txtdata_w = 0;
uint1  txtwrite  = 0;

text_buffer txtbuf (
  clk     <: clock,
  addr    <: txtaddr,
  wdata   <: txtdata_w,
  rdata   :> txtdata_r,
  wenable <: txtwrite
);

// ---------- font

  uint1 letters[2432] = {
  //[0] 0
  0,0,1,1,1,1,0,0,
  0,1,0,0,0,1,1,0,
  0,1,0,0,1,0,1,0,
  0,1,0,0,1,0,1,0,
  0,1,0,1,0,0,1,0,
  0,1,0,1,0,0,1,0,
  0,1,1,0,0,0,1,0,
  0,0,1,1,1,1,0,0,
  // 1
  0,0,0,0,1,0,0,0,
  0,0,0,1,1,0,0,0,
  0,0,1,0,1,0,0,0,
  0,0,0,0,1,0,0,0,
  0,0,0,0,1,0,0,0,
  0,0,0,0,1,0,0,0,
  0,0,0,0,1,0,0,0,
  0,0,0,1,1,1,0,0,
  // 2
  0,0,1,1,1,1,0,0,
  0,1,0,0,0,0,1,0,
  0,1,0,0,0,0,1,0,
  0,0,0,0,1,1,1,0,
  0,0,0,1,0,0,0,0,
  0,0,1,0,0,0,0,0,
  0,1,0,0,0,0,0,0,
  0,1,1,1,1,1,0,0,
  // 3
  0,0,1,1,1,1,0,0,
  0,1,0,0,0,0,1,0,
  0,0,0,0,0,0,1,0,
  0,0,0,1,1,1,0,0,
  0,0,0,0,0,1,0,0,
  0,0,0,0,0,0,1,0,
  0,0,0,0,0,0,1,0,
  0,1,1,1,1,1,0,0,
  // 4
  0,0,0,0,0,1,0,0,
  0,0,0,0,1,1,0,0,
  0,0,0,1,0,1,0,0,
  0,0,1,0,0,1,0,0,
  0,1,1,1,1,1,1,0,
  0,0,0,0,0,1,0,0,
  0,0,0,0,0,1,0,0,
  0,0,0,0,0,1,0,0,
  // 5
  0,1,1,1,1,1,1,0,
  0,1,0,0,0,0,0,0,
  0,1,0,0,0,0,0,0,
  0,1,0,0,0,0,0,0,
  0,1,1,1,1,1,0,0,
  0,0,0,0,0,0,1,0,
  0,0,0,0,0,0,1,0,
  0,1,1,1,1,1,0,0,
  // 6
  0,0,0,0,0,1,1,0,
  0,0,0,0,1,0,0,0,
  0,0,0,1,0,0,0,0,
  0,0,1,0,0,0,0,0,
  0,1,1,1,1,1,0,0,
  1,0,0,0,0,0,1,0,
  1,0,0,0,0,0,1,0,
  0,1,1,1,1,1,0,0,
  // 7
  0,1,1,1,1,1,0,0,
  0,0,0,0,0,0,1,0,
  0,0,0,0,0,1,0,0,
  0,0,0,0,0,1,0,0,
  0,0,0,0,0,1,0,0,
  0,0,0,0,1,0,0,0,
  0,0,0,0,1,0,0,0,
  0,0,0,0,1,0,0,0,
  // 8
  0,1,1,1,1,1,0,0,
  1,0,0,0,0,0,1,0,
  1,0,0,0,0,0,1,0,
  1,0,0,0,0,0,1,0,
  0,1,1,1,1,1,0,0,
  1,0,0,0,0,0,1,0,
  1,0,0,0,0,0,1,0,
  0,1,1,1,1,1,0,0,
  // [9] 9
  0,1,1,1,1,1,0,0,
  1,0,0,0,0,0,1,0,
  1,0,0,0,0,0,1,0,
  0,1,1,1,1,1,0,0,
  0,0,0,0,0,1,0,0,
  0,0,0,0,1,0,0,0,
  0,0,0,1,0,0,0,0,
  0,0,1,0,0,0,0,0,
  //[10] a
  0,0,0,1,1,0,0,0,
  0,0,1,0,0,1,0,0,
  0,1,0,0,0,0,1,0,
  0,1,0,0,0,0,1,0,
  0,1,1,1,1,1,1,0,
  0,1,0,0,0,0,1,0,
  0,1,0,0,0,0,1,0,
  0,1,0,0,0,0,1,0,
  // b
  0,1,1,1,1,0,0,0,
  0,1,0,0,0,1,0,0,
  0,1,0,0,0,1,0,0,
  0,1,0,0,1,0,0,0,
  0,1,1,1,1,1,0,0,
  0,1,0,0,0,0,1,0,
  0,1,0,0,0,0,1,0,
  0,1,1,1,1,1,0,0,
  // c
  0,0,0,1,1,1,0,0,
  0,0,1,0,0,0,0,0,
  0,1,0,0,0,0,0,0,
  0,1,0,0,0,0,0,0,
  0,1,0,0,0,0,0,0,
  0,1,0,0,0,0,0,0,
  0,0,1,0,0,0,0,0,
  0,0,0,1,1,1,1,0,
  // d
  0,1,1,1,1,0,0,0,
  0,1,0,0,0,1,0,0,
  0,1,0,0,0,0,1,0,
  0,1,0,0,0,0,1,0,
  0,1,0,0,0,0,1,0,
  0,1,0,0,0,0,1,0,
  0,1,0,0,0,1,1,0,
  0,1,1,1,1,0,0,0,
  // e
  0,1,1,1,1,1,0,0,
  0,1,0,0,0,0,0,0,
  0,1,0,0,0,0,0,0,
  0,1,1,1,0,0,0,0,
  0,1,0,0,0,0,0,0,
  0,1,0,0,0,0,0,0,
  0,1,0,0,0,0,0,0,
  0,1,1,1,1,1,1,0,
  // f
  0,1,1,1,1,1,1,0,
  0,1,0,0,0,0,0,0,
  0,1,0,0,0,0,0,0,
  0,1,0,0,0,0,0,0,
  0,1,1,1,0,0,0,0,
  0,1,0,0,0,0,0,0,
  0,1,0,0,0,0,0,0,
  0,1,0,0,0,0,0,0,
  // g
  0,0,0,1,1,1,0,0,
  0,0,1,0,0,0,0,0,
  0,1,0,0,0,0,0,0,
  0,1,0,0,0,0,0,0,
  0,1,0,0,1,1,1,0,
  0,1,0,0,0,0,1,0,
  0,0,1,0,0,0,1,0,
  0,0,0,1,1,1,1,0,
  // h
  0,1,0,0,0,0,1,0,
  0,1,0,0,0,0,1,0,
  0,1,0,0,0,0,1,0,
  0,1,1,1,1,1,1,0,
  0,1,0,0,0,0,1,0,
  0,1,0,0,0,0,1,0,
  0,1,0,0,0,0,1,0,
  0,1,0,0,0,0,1,0,
  // i
  0,0,0,1,1,0,0,0,
  0,0,0,1,1,0,0,0,
  0,0,0,0,0,0,0,0,
  0,0,0,0,1,0,0,0,
  0,0,0,0,1,0,0,0,
  0,0,0,0,1,0,0,0,
  0,0,0,0,1,0,0,0,
  0,0,0,0,1,0,0,0,
  // j
  0,0,0,0,1,1,0,0,
  0,0,0,0,1,1,0,0,
  0,0,0,0,0,0,0,0,
  0,0,0,0,0,1,0,0,
  0,0,0,0,0,1,0,0,
  0,0,0,0,0,1,0,0,
  0,1,0,0,0,1,0,0,
  0,0,1,1,1,0,0,0,
  // k
  0,1,0,0,1,0,0,0,
  0,1,0,0,1,0,0,0,
  0,1,0,0,1,0,0,0,
  0,1,0,1,0,0,0,0,
  0,1,1,1,0,0,0,0,
  0,1,0,0,1,0,0,0,
  0,1,0,0,0,1,0,0,
  0,1,0,0,0,1,0,0,
  // l
  0,1,0,0,0,0,0,0,
  0,1,0,0,0,0,0,0,
  0,1,0,0,0,0,0,0,
  0,1,0,0,0,0,0,0,
  0,1,0,0,0,0,0,0,
  0,1,0,0,0,0,0,0,
  0,1,0,0,0,0,0,0,
  0,0,1,1,1,1,0,0,
  // m
  0,0,0,0,0,0,0,0,
  0,1,1,0,0,1,1,0,
  1,0,0,1,1,0,0,1,
  1,0,0,0,0,0,0,1,
  1,0,0,0,0,0,0,1,
  1,0,0,0,0,0,0,1,
  1,0,0,0,0,0,0,1,
  1,0,0,0,0,0,0,1,
  // n
  0,1,0,0,0,0,1,0,
  0,1,1,0,0,0,1,0,
  0,1,0,1,0,0,1,0,
  0,1,0,0,1,0,1,0,
  0,1,0,0,0,1,1,0,
  0,1,0,0,0,0,1,0,
  0,1,0,0,0,0,1,0,
  0,1,0,0,0,0,1,0,
  // o
  0,0,1,1,1,1,0,0,
  0,1,0,0,0,0,1,0,
  0,1,0,0,0,0,1,0,
  0,1,0,0,0,0,1,0,
  0,1,0,0,0,0,1,0,
  0,1,0,0,0,0,1,0,
  0,1,0,0,0,0,1,0,
  0,0,1,1,1,1,0,0,
  // p
  0,0,1,1,1,1,0,0,
  0,0,1,0,0,0,1,0,
  0,0,1,0,0,0,1,0,
  0,0,1,0,0,0,1,0,
  0,0,1,1,1,1,1,0,
  0,0,1,0,0,0,0,0,
  0,0,1,0,0,0,0,0,
  0,0,1,0,0,0,0,0,
  // q
  0,0,1,1,1,1,0,0,
  0,1,0,0,0,0,1,0,
  0,1,0,0,0,0,1,0,
  0,1,0,0,0,0,1,0,
  0,1,0,0,0,0,1,0,
  0,1,0,1,0,0,1,0,
  0,0,1,0,0,0,1,0,
  0,1,0,1,1,1,0,0,
  // r
  0,1,1,1,1,1,0,0,
  0,1,0,0,0,0,1,0,
  0,1,0,0,0,0,1,0,
  0,1,0,0,0,0,1,0,
  0,1,1,1,1,1,0,0,
  0,1,0,0,0,1,0,0,
  0,1,0,0,0,0,1,0,
  0,1,0,0,0,0,0,1,
  // s
  0,0,1,1,1,1,0,0,
  0,1,0,0,0,0,1,0,
  0,1,0,0,0,0,0,0,
  0,1,0,0,0,0,0,0,
  0,0,1,1,1,1,0,0,
  0,0,0,0,0,0,1,0,
  0,0,0,0,0,0,1,0,
  0,1,1,1,1,1,0,0,
  // t
  1,1,1,1,1,1,1,0,
  0,0,0,1,0,0,0,0,
  0,0,0,1,0,0,0,0,
  0,0,0,1,0,0,0,0,
  0,0,0,1,0,0,0,0,
  0,0,0,1,0,0,0,0,
  0,0,0,1,0,0,0,0,
  0,0,0,1,0,0,0,0,
  // u
  0,1,0,0,0,0,1,0,
  0,1,0,0,0,0,1,0,
  0,1,0,0,0,0,1,0,
  0,1,0,0,0,0,1,0,
  0,1,0,0,0,0,1,0,
  0,1,0,0,0,0,1,0,
  0,1,0,0,0,0,1,0,
  0,0,1,1,1,1,0,0,
  // v
  1,0,0,0,0,0,0,1,
  1,0,0,0,0,0,0,1,
  1,0,0,0,0,0,0,1,
  0,1,0,0,0,0,1,0,
  0,1,0,0,0,0,1,0,
  0,0,1,0,0,1,0,0,
  0,0,1,0,0,1,0,0,
  0,0,0,1,1,0,0,0,
  // w
  1,0,0,0,0,0,0,1,
  1,0,0,0,0,0,0,1,
  1,0,0,0,0,0,0,1,
  1,0,0,0,0,0,0,1,
  0,1,0,0,0,0,1,0,
  0,1,0,1,1,0,1,0,
  0,1,0,1,1,0,1,0,
  0,0,1,0,0,1,0,0,
  // x
  0,1,0,0,0,1,0,0,
  0,1,0,0,0,1,0,0,
  0,1,0,0,0,1,0,0,
  0,0,1,0,1,0,0,0,
  0,0,0,1,0,0,0,0,
  0,0,1,0,1,0,0,0,
  0,1,0,0,0,1,0,0,
  0,1,0,0,0,1,0,0,
  // y
  1,0,0,0,0,1,0,0,
  1,0,0,0,0,1,0,0,
  0,1,0,0,1,0,0,0,
  0,0,1,0,1,0,0,0,
  0,0,0,1,0,0,0,0,
  0,0,0,1,0,0,0,0,
  0,0,1,0,0,0,0,0,
  0,0,1,0,0,0,0,0,
  //[35] z
  0,1,1,1,1,1,1,0,
  0,0,0,0,0,0,1,0,
  0,0,0,0,0,1,0,0,
  0,0,0,0,1,0,0,0,
  0,0,0,1,0,0,0,0,
  0,0,1,0,0,0,0,0,
  0,1,0,0,0,0,0,0,
  0,1,1,1,1,1,1,0,
  //[36] <space>
  0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,
  //[37] <->
  0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,
  0,1,1,1,1,1,1,0,
  0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0,
  0,0,0,0,0,0,0,0
  };

  // ---------- text display

  uint8  text_i   = 0;
  uint7  text_j   = 0;
  uint3  letter_i = 0;
  uint4  letter_j = 0;
  uint1  pixel    = 0;
  uint12 addr     = 0;

  uint16 next     = 0;

  uint8  lttr     = 0;
  uint11 col      = 0;
  uint11 str_x    = 64;
  uint10 str_y    = 39;

  uint8  str_start = 0;
  uint8  str_len   = 0;

  uint16 recip10  = 16h199A;
  uint32 mulr10   = 0;
 
  uint8  dividend = 243;
  uint8  divisor  = 13;
  div    div0;
  
  int16  numb     = 0;
  uint16 numb_tmp = 0;
  uint8  numb_cnt = 0;
  
  // ---------- string
  
  uint8  str[] = "DIVISION TEST EQUALS DIV BY "; 
  uint8  tmp   = 0;
  uint8  step  = 0;

  // --------- print string 

  subroutine print_string:
    col  = 0;
    lttr = str[str_start];
    while (lttr != 0 && col < str_len) {
      if (lttr == 32) {
        lttr = 36;
      } else {
        lttr = lttr - 55;
      }
      txtaddr   = col + str_x + str_y * 160;    
      txtdata_w = lttr[0,6];
      col       = col + 1;  
      str_start = str_start + 1;
      lttr      = str[str_start];
    }
    str_x = str_x + col;
  return;

  // --------- print number 
  subroutine print_number:
    if (numb < 0) {
      numb_cnt = 1;
      numb_tmp = -numb;
    } else {
      numb_cnt = 0;
      numb_tmp = numb;
    }
    while (numb_tmp > 0) {
      numb_cnt = numb_cnt + 1;
      numb_tmp = numb_tmp >> 4;
    }
    col = 0;
    if (numb < 0) {
      numb_tmp = -numb;
      // output sign
      txtaddr   = str_x + str_y * 160;    
      txtdata_w = 37;
    } else {
      numb_tmp = numb;
    }
    while (numb_tmp > 0) {
      mulr10    = numb_tmp * recip10;
      lttr      = numb_tmp - 10 * (mulr10 >> 16);
      numb_tmp  = (mulr10 >> 16);
      txtaddr   = numb_cnt - col + str_x + str_y * 160;    
      txtdata_w = lttr[0,6];
      col       = col + 1;
    }
    str_x = str_x + col;
  return;

  // fill buffer with spaces
  txtwrite  = 1;
  next      = 0;
  txtdata_w = 36; // data to write
  while (next < 12800) {
    txtaddr = next;     // address to write
    next    = next + 1; // next
  } // takes two cycles to loop, write occurs on first

  // print title string

  str_x     = 64;
  str_start = 0;
  str_len   = 13;
  call print_string;
  str_y     = str_y + 2;

  // print division

  str_x     = 64;
  numb      = dividend;
  call print_number;

  str_start = 20;  // div by
  str_len   = 8;
  call print_string;

  numb = divisor;
  call print_number;

  str_start = 13;  // equals
  str_len   = 7;
  call print_string;

  (numb) <- div0 <- (dividend,divisor);
  call print_number;
  str_y = str_y + 1;
  
  // ---------- show time!

  // stop writing to buffer
  txtwrite = 0;
  txtaddr  = 0;   

  loop:
    
    hdmi_red   = 0;
    hdmi_green = 0;
    hdmi_blue  = 0;

    if (letter_j < 8) {
      letter_i = hdmi_x & 7;
      addr     = letter_i + (letter_j << 3) + (txtdata_r << 6);
      pixel    = letters[ addr ];
      if (hdmi_active && pixel == 1) {
        hdmi_red   = 255;
        hdmi_green = 255;
        hdmi_blue  = 255;
      }
    }

    if (hdmi_active && (hdmi_x & 7) == 7) {   // end of letter
      text_i = text_i + 1;
      if (hdmi_x == 1279) {  // end of line
        // back to first column
        text_i   = 0;
        // next letter line
        if (letter_j < 8) {
          letter_j = letter_j + 1;
        } else {
          // next row
          letter_j = 0;
          text_j   = text_j + 1;
        }
        if (hdmi_y == 719) {
          // end of frame
          text_i   = 0;
          text_j   = 0;
          letter_j = 0;      
        }
      }
    } 

    txtaddr  = text_i + text_j * 160;

  goto loop;
}

// ------------------------- 
