module scrambler(CLK,
		 RST_N,

		 in_data,
		 EN_in,
		 RDY_in,

		 seed_value,
		 EN_seed,
		 RDY_seed,

		 EN_out,
		 out,
		 RDY_out);
  input  CLK;
  input  RST_N;

  // action method in
  input  [3 : 0] in_data;
  input  EN_in;
  output RDY_in;

  // action method seed
  input  [3 : 0] seed_value;
  input  EN_seed;
  output RDY_seed;

  // actionvalue method out
  input  EN_out;
  output [3 : 0] out;
  output RDY_out;

  // signals for module outputs
  wire [3 : 0] out;
  wire RDY_in, RDY_out, RDY_seed;

  // register ff
  reg [4 : 0] ff;
  wire [4 : 0] ff$D_IN;
  wire ff$EN;

  // register xx_r
  reg [3 : 0] xx_r;
  wire [3 : 0] xx_r$D_IN;
  wire xx_r$EN;

  // inputs to muxes for submodule ports
  wire [3 : 0] MUX_xx_r$write_1__VAL_2;

  // action method in
  assign RDY_in = 1'd1 ;

  // action method seed
  assign RDY_seed = 1'd1 ;

  // actionvalue method out
  assign out = xx_r ^ ff[3:0] ;
  assign RDY_out = ff[4] ;

  // inputs to muxes for submodule ports
  assign MUX_xx_r$write_1__VAL_2 =
	     xx_r[0] ? { 1'd1, xx_r[3:2], ~xx_r[1] } : { 1'd0, xx_r[3:1] } ;

  // register ff
  assign ff$D_IN = { 1'd1, in_data } ;
  assign ff$EN = EN_in ;

  // register xx_r
  assign xx_r$D_IN = EN_seed ? seed_value : MUX_xx_r$write_1__VAL_2 ;
  assign xx_r$EN = EN_seed || EN_out ;

  // handling of inlined registers
  
  always@(posedge CLK)
  begin
    if (RST_N == `BSV_RESET_VALUE)
      begin
        xx_r <= `BSV_ASSIGNMENT_DELAY 4'd1;
      end
    else
      begin
        if (xx_r$EN) xx_r <= `BSV_ASSIGNMENT_DELAY xx_r$D_IN;
      end
  end

  always@(posedge CLK or `BSV_RESET_EDGE RST_N)
  if (RST_N == `BSV_RESET_VALUE)
    begin
      ff <= `BSV_ASSIGNMENT_DELAY 5'd10;
    end
  else
    begin
      if (ff$EN) ff <= `BSV_ASSIGNMENT_DELAY ff$D_IN;
    end

  // synopsys translate_off
  `ifdef BSV_NO_INITIAL_BLOCKS
  `else // not BSV_NO_INITIAL_BLOCKS
  initial
  begin
    ff = 5'h0A;
    xx_r = 4'hA;
  end
  `endif // BSV_NO_INITIAL_BLOCKS
  // synopsys translate_on
endmodule  // scrambler
