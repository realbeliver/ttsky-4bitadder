`timescale 1ns / 1ps

module tb;

    // Test parameters
    parameter CLK_PERIOD = 10;  // 10ns clock period
    
    // Common signals
    reg clk;
    integer test_count = 0;
    integer pass_count = 0;
    
    // ============================================================
    // BUFFER_CELL TESTBENCH
    // ============================================================
    
    reg buf_in;
    wire buf_out;
    
    buffer_cell buf_uut (
        .in(buf_in),
        .out(buf_out)
    );
    
    // ============================================================
    // AND_CELL TESTBENCH
    // ============================================================
    
    reg and_a, and_b;
    wire and_out;
    
    and_cell and_uut (
        .a(and_a),
        .b(and_b),
        .out(and_out)
    );
    
    // ============================================================
    // OR_CELL TESTBENCH
    // ============================================================
    
    reg or_a, or_b;
    wire or_out;
    
    or_cell or_uut (
        .a(or_a),
        .b(or_b),
        .out(or_out)
    );
    
    // ============================================================
    // XOR_CELL TESTBENCH
    // ============================================================
    
    reg xor_a, xor_b;
    wire xor_out;
    
    xor_cell xor_uut (
        .a(xor_a),
        .b(xor_b),
        .out(xor_out)
    );
    
    // ============================================================
    // NAND_CELL TESTBENCH
    // ============================================================
    
    reg nand_a, nand_b;
    wire nand_out;
    
    nand_cell nand_uut (
        .a(nand_a),
        .b(nand_b),
        .out(nand_out)
    );
    
    // ============================================================
    // NOT_CELL TESTBENCH
    // ============================================================
    
    reg not_in;
    wire not_out;
    
    not_cell not_uut (
        .in(not_in),
        .out(not_out)
    );
    
    // ============================================================
    // MUX_CELL TESTBENCH
    // ============================================================
    
    reg mux_a, mux_b, mux_sel;
    wire mux_out;
    
    mux_cell mux_uut (
        .a(mux_a),
        .b(mux_b),
        .sel(mux_sel),
        .out(mux_out)
    );
    
    // ============================================================
    // DFF_CELL TESTBENCH
    // ============================================================
    
    reg dff_d;
    wire dff_q, dff_notq;
    
    dff_cell dff_uut (
        .clk(clk),
        .d(dff_d),
        .q(dff_q),
        .notq(dff_notq)
    );
    
    // ============================================================
    // DFFSR_CELL TESTBENCH
    // ============================================================
    
    reg dffsr_d, dffsr_s, dffsr_r;
    wire dffsr_q, dffsr_notq;
    
    dffsr_cell dffsr_uut (
        .clk(clk),
        .d(dffsr_d),
        .s(dffsr_s),
        .r(dffsr_r),
        .q(dffsr_q),
        .notq(dffsr_notq)
    );
    
    // ============================================================
    // CLOCK GENERATION
    // ============================================================
    
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end
    
    // ============================================================
    // TEST PROCEDURES
    // ============================================================
    
    initial begin
        $display("===============================================");
        $display("    CELL FUNCTIONAL VERIFICATION TESTBENCH");
        $display("===============================================\n");
        
        // Test BUFFER_CELL
        test_buffer_cell;
        
        // Test AND_CELL
        test_and_cell;
        
        // Test OR_CELL
        test_or_cell;
        
        // Test XOR_CELL
        test_xor_cell;
        
        // Test NAND_CELL
        test_nand_cell;
        
        // Test NOT_CELL
        test_not_cell;
        
        // Test MUX_CELL
        test_mux_cell;
        
        // Test DFF_CELL
        test_dff_cell;
        
        // Test DFFSR_CELL
        test_dffsr_cell;
        
        // Print summary
        $display("\n===============================================");
        $display("    TEST SUMMARY");
        $display("===============================================");
        $display("Total Tests: %0d", test_count);
        $display("Passed:      %0d", pass_count);
        $display("Failed:      %0d", test_count - pass_count);
        $display("===============================================\n");
        
        if (test_count == pass_count) begin
            $display("✓ ALL TESTS PASSED!");
        end else begin
            $display("✗ SOME TESTS FAILED!");
        end
        
        $finish;
    end
    
    // ============================================================
    // TEST TASKS
    // ============================================================
    
    task test_buffer_cell;
        $display("\n[BUFFER_CELL] Testing...");
        
        // Test 0 -> 0
        buf_in = 1'b0;
        #1;
        assert_equal(buf_out, 1'b0, "Buffer: 0 -> 0");
        
        // Test 1 -> 1
        buf_in = 1'b1;
        #1;
        assert_equal(buf_out, 1'b1, "Buffer: 1 -> 1");
    endtask
    
    task test_and_cell;
        $display("[AND_CELL] Testing...");
        
        and_a = 1'b0; and_b = 1'b0; #1;
        assert_equal(and_out, 1'b0, "AND: 0 & 0 = 0");
        
        and_a = 1'b0; and_b = 1'b1; #1;
        assert_equal(and_out, 1'b0, "AND: 0 & 1 = 0");
        
        and_a = 1'b1; and_b = 1'b0; #1;
        assert_equal(and_out, 1'b0, "AND: 1 & 0 = 0");
        
        and_a = 1'b1; and_b = 1'b1; #1;
        assert_equal(and_out, 1'b1, "AND: 1 & 1 = 1");
    endtask
    
    task test_or_cell;
        $display("[OR_CELL] Testing...");
        
        or_a = 1'b0; or_b = 1'b0; #1;
        assert_equal(or_out, 1'b0, "OR: 0 | 0 = 0");
        
        or_a = 1'b0; or_b = 1'b1; #1;
        assert_equal(or_out, 1'b1, "OR: 0 | 1 = 1");
        
        or_a = 1'b1; or_b = 1'b0; #1;
        assert_equal(or_out, 1'b1, "OR: 1 | 0 = 1");
        
        or_a = 1'b1; or_b = 1'b1; #1;
        assert_equal(or_out, 1'b1, "OR: 1 | 1 = 1");
    endtask
    
    task test_xor_cell;
        $display("[XOR_CELL] Testing...");
        
        xor_a = 1'b0; xor_b = 1'b0; #1;
        assert_equal(xor_out, 1'b0, "XOR: 0 ^ 0 = 0");
        
        xor_a = 1'b0; xor_b = 1'b1; #1;
        assert_equal(xor_out, 1'b1, "XOR: 0 ^ 1 = 1");
        
        xor_a = 1'b1; xor_b = 1'b0; #1;
        assert_equal(xor_out, 1'b1, "XOR: 1 ^ 0 = 1");
        
        xor_a = 1'b1; xor_b = 1'b1; #1;
        assert_equal(xor_out, 1'b0, "XOR: 1 ^ 1 = 0");
    endtask
    
    task test_nand_cell;
        $display("[NAND_CELL] Testing...");
        
        nand_a = 1'b0; nand_b = 1'b0; #1;
        assert_equal(nand_out, 1'b1, "NAND: ~(0 & 0) = 1");
        
        nand_a = 1'b0; nand_b = 1'b1; #1;
        assert_equal(nand_out, 1'b1, "NAND: ~(0 & 1) = 1");
        
        nand_a = 1'b1; nand_b = 1'b0; #1;
        assert_equal(nand_out, 1'b1, "NAND: ~(1 & 0) = 1");
        
        nand_a = 1'b1; nand_b = 1'b1; #1;
        assert_equal(nand_out, 1'b0, "NAND: ~(1 & 1) = 0");
    endtask
    
    task test_not_cell;
        $display("[NOT_CELL] Testing...");
        
        not_in = 1'b0; #1;
        assert_equal(not_out, 1'b1, "NOT: ~0 = 1");
        
        not_in = 1'b1; #1;
        assert_equal(not_out, 1'b0, "NOT: ~1 = 0");
    endtask
    
    task test_mux_cell;
        $display("[MUX_CELL] Testing...");
        
        // sel = 0 selects a
        mux_a = 1'b0; mux_b = 1'b1; mux_sel = 1'b0; #1;
        assert_equal(mux_out, 1'b0, "MUX: sel=0, a=0, b=1 -> 0");
        
        mux_a = 1'b1; mux_b = 1'b0; mux_sel = 1'b0; #1;
        assert_equal(mux_out, 1'b1, "MUX: sel=0, a=1, b=0 -> 1");
        
        // sel = 1 selects b
        mux_a = 1'b0; mux_b = 1'b1; mux_sel = 1'b1; #1;
        assert_equal(mux_out, 1'b1, "MUX: sel=1, a=0, b=1 -> 1");
        
        mux_a = 1'b1; mux_b = 1'b0; mux_sel = 1'b1; #1;
        assert_equal(mux_out, 1'b0, "MUX: sel=1, a=1, b=0 -> 0");
    endtask
    
    task test_dff_cell;
        $display("[DFF_CELL] Testing...");
        
        // Test basic D flip-flop operation
        dff_d = 1'b1;
        @(posedge clk);
        @(negedge clk);
        assert_equal(dff_q, 1'b1, "DFF: After clock, q=1");
        assert_equal(dff_notq, 1'b0, "DFF: After clock, notq=0");
        
        dff_d = 1'b0;
        @(posedge clk);
        @(negedge clk);
        assert_equal(dff_q, 1'b0, "DFF: After clock, q=0");
        assert_equal(dff_notq, 1'b1, "DFF: After clock, notq=1");
        
        // Test complementary outputs
        dff_d = 1'b1;
        @(posedge clk);
        @(negedge clk);
        assert_equal(dff_notq, ~dff_q, "DFF: notq is complement of q");
    endtask
    
    task test_dffsr_cell;
        $display("[DFFSR_CELL] Testing...");
        
        dffsr_d = 1'b0;
        dffsr_s = 1'b0;
        dffsr_r = 1'b0;
        
        // Test reset (r = 1)
        dffsr_r = 1'b1;
        #1;
        assert_equal(dffsr_q, 1'b0, "DFFSR: Reset clears q");
        dffsr_r = 1'b0;
        
        // Test set (s = 1)
        dffsr_s = 1'b1;
        #1;
        assert_equal(dffsr_q, 1'b1, "DFFSR: Set sets q=1");
        dffsr_s = 1'b0;
        
        // Test normal D flip-flop operation
        dffsr_d = 1'b0;
        @(posedge clk);
        @(negedge clk);
        assert_equal(dffsr_q, 1'b0, "DFFSR: After clock, q=0");
        
        dffsr_d = 1'b1;
        @(posedge clk);
        @(negedge clk);
        assert_equal(dffsr_q, 1'b1, "DFFSR: After clock, q=1");
        
        // Test reset priority over set
        dffsr_s = 1'b1;
        dffsr_r = 1'b1;
        #1;
        assert_equal(dffsr_q, 1'b0, "DFFSR: Reset has priority over set");
    endtask
    
    // ============================================================
    // ASSERTION HELPER
    // ============================================================
    
    task assert_equal;
        input actual, expected;
        input string test_name;
        
        test_count = test_count + 1;
        if (actual === expected) begin
            pass_count = pass_count + 1;
            $display("  ✓ PASS: %s (actual=%b, expected=%b)", test_name, actual, expected);
        end else begin
            $display("  ✗ FAIL: %s (actual=%b, expected=%b)", test_name, actual, expected);
        end
    endtask

endmodule
