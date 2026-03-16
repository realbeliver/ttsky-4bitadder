`timescale 1ns / 1ps

module tb_cells();

    // Inputs
    reg a, b, sel, in;
    reg clk, d, s, r;

    // Outputs
    wire out_buf, out_and, out_or, out_xor, out_nand, out_not, out_mux;
    wire q_dff, notq_dff, q_dffsr, notq_dffsr;

    // Instantiate Combinational Cells
    buffer_cell u_buf  (.in(in), .out(out_buf));
    and_cell    u_and  (.a(a), .b(b), .out(out_and));
    or_cell     u_or   (.a(a), .b(b), .out(out_or));
    xor_cell    u_xor  (.a(a), .b(b), .out(out_xor));
    nand_cell   u_nand (.a(a), .b(b), .out(out_nand));
    not_cell    u_not  (.in(in), .out(out_not));
    mux_cell    u_mux  (.a(a), .b(b), .sel(sel), .out(out_mux));

    // Instantiate Sequential Cells
    dff_cell    u_dff   (.clk(clk), .d(d), .q(q_dff), .notq(notq_dff));
    dffsr_cell  u_dffsr (.clk(clk), .d(d), .s(s), .r(r), .q(q_dffsr), .notq(notq_dffsr));

    // Clock Generation (100MHz)
    always #5 clk = ~clk;

    initial begin
        // Initialize
        clk = 0; a = 0; b = 0; sel = 0; in = 0;
        d = 0; s = 0; r = 0;

        $monitor("Time=%0t | in=%b a=%b b=%b sel=%b | AND=%b OR=%b XOR=%b MUX=%b | DFF_Q=%b DFFSR_Q=%b", 
                 $time, in, a, b, sel, out_and, out_or, out_xor, out_mux, q_dff, q_dffsr);

        // --- Test Combinational Logic ---
        #10 in = 1; a = 0; b = 1;
        #10 a = 1; b = 0;
        #10 a = 1; b = 1;
        #10 sel = 1; // Test Mux switching to 'b'

        // --- Test D-FlipFlop (DFF) ---
        #10 d = 1; 
        #10 d = 0;

        // --- Test DFF with Set/Reset (DFFSR) ---
        #10 r = 1; // Assert Reset
        #10 r = 0; d = 1;
        #10 s = 1; // Assert Set (Override D)
        #10 s = 0;

        #50 $finish;
    end

endmodule
