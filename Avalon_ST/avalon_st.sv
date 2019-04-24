rface avalon_st_sink
    #();
    // Fundamental signals
    input clk,              // 1
    input ready,            // 1       Sink -> Source 
    input valid,            // 1       Source -> Sink
    input data,             // 1..256  Source -> Sink
    input channel           // 0..31   Source -> Sink
    input error             // 0..256  Source -> Sink
    // Packet transfer signals
    input startofpacket     // 1 Source -> Sink
    input endofpacket       // 1 Source -> Sink
    input empty             // log2(Symbols_per_clk)
    // Other Signal
    input resetn

    // PARAMETRS
    parameter   BITS_PER_SYMBOL
    parameter   SYMBOL_PER_BEAT
    parameter   SYMBOL_TYPE
    parameter   READY_LATENCY
    parameter   ERROR_DESCRIPTION
    parameter   MAX_CHANNEL
    parameter   CYCLES_PER_BURST
    parameter   PACKETS_PER_BURST
    parameter   CYCLES_PER_BLOCK
    parameter   PACKETS_PER_BLOCK
    parameter
endinterface



interface avalon_st_source
    #();
    // Fundamental signals
    input clk,              // 1
    input ready,            // 1       Sink -> Source 
    input valid,            // 1       Source -> Sink
    input data,             // 1..256  Source -> Sink
    input channel           // 0..31   Source -> Sink
    input error             // 0..256  Source -> Sink
    // Packet transfer signals
    input startofpacket     // 1 Source -> Sink
    input endofpacket       // 1 Source -> Sink
    input empty             // log2(Symbols_per_clk)
    // Other Signal
    input resetn

    // PARAMETRS
    parameter   BITS_PER_SYMBOL
    parameter   SYMBOL_PER_BEAT
    parameter   SYMBOL_TYPE
    parameter   READY_LATENCY
    parameter   ERROR_DESCRIPTION
    parameter   MAX_CHANNEL
    parameter   CYCLES_PER_BURST
    parameter   PACKETS_PER_BURST
    parameter   CYCLES_PER_BLOCK
    parameter   PACKETS_PER_BLOCK
    parameter
endinterface