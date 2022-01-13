library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.local_types.all;

entity hc_sr04_ctrls_v1_0 is
    generic (
        -- Users to add parameters here
        CLK_FREQ_HZ : natural := 100e6;
        -- Subtypes are not supported in Vivado IP Packager
        NUM_SENSORS : natural range 1 to NUM_SENSORS_MAX := 1;
        -- User parameters ends
        -- Do not modify the parameters beyond this line


        -- Parameters of Axi Slave Bus Interface S00_AXI
        C_S00_AXI_DATA_WIDTH    : integer   := 32;
        C_S00_AXI_ADDR_WIDTH    : integer   := 6
    );
    port (
        -- Users to add ports here
        trigs_out : out std_logic_vector(NUM_SENSORS-1 downto 0);
        echos_in : in std_logic_vector(NUM_SENSORS-1 downto 0);
        -- User ports ends
        -- Do not modify the ports beyond this line


        -- Ports of Axi Slave Bus Interface S00_AXI
        s00_axi_aclk    : in std_logic;
        s00_axi_aresetn : in std_logic;
        s00_axi_awaddr  : in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
        s00_axi_awprot  : in std_logic_vector(2 downto 0);
        s00_axi_awvalid : in std_logic;
        s00_axi_awready : out std_logic;
        s00_axi_wdata   : in std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
        s00_axi_wstrb   : in std_logic_vector((C_S00_AXI_DATA_WIDTH/8)-1 downto 0);
        s00_axi_wvalid  : in std_logic;
        s00_axi_wready  : out std_logic;
        s00_axi_bresp   : out std_logic_vector(1 downto 0);
        s00_axi_bvalid  : out std_logic;
        s00_axi_bready  : in std_logic;
        s00_axi_araddr  : in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
        s00_axi_arprot  : in std_logic_vector(2 downto 0);
        s00_axi_arvalid : in std_logic;
        s00_axi_arready : out std_logic;
        s00_axi_rdata   : out std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
        s00_axi_rresp   : out std_logic_vector(1 downto 0);
        s00_axi_rvalid  : out std_logic;
        s00_axi_rready  : in std_logic
    );
end hc_sr04_ctrls_v1_0;

architecture arch_imp of hc_sr04_ctrls_v1_0 is

    -- component declaration
    component hc_sr04_ctrls_v1_0_S00_AXI is
        generic (
        -- User
        NUM_SENSORS : natural range 1 to NUM_SENSORS_MAX := 1;
        -- User end
        C_S_AXI_DATA_WIDTH  : integer   := 32;
        C_S_AXI_ADDR_WIDTH  : integer   := 6
        );
        port (
        -- User
        SENSORS_EN_OUT : out std_logic_vector(NUM_SENSORS-1 downto 0);
        DISTANCES_IN : in slv32_bus_t(NUM_SENSORS-1 downto 0);
        -- User end
        S_AXI_ACLK  : in std_logic;
        S_AXI_ARESETN   : in std_logic;
        S_AXI_AWADDR    : in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
        S_AXI_AWPROT    : in std_logic_vector(2 downto 0);
        S_AXI_AWVALID   : in std_logic;
        S_AXI_AWREADY   : out std_logic;
        S_AXI_WDATA : in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        S_AXI_WSTRB : in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
        S_AXI_WVALID    : in std_logic;
        S_AXI_WREADY    : out std_logic;
        S_AXI_BRESP : out std_logic_vector(1 downto 0);
        S_AXI_BVALID    : out std_logic;
        S_AXI_BREADY    : in std_logic;
        S_AXI_ARADDR    : in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
        S_AXI_ARPROT    : in std_logic_vector(2 downto 0);
        S_AXI_ARVALID   : in std_logic;
        S_AXI_ARREADY   : out std_logic;
        S_AXI_RDATA : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
        S_AXI_RRESP : out std_logic_vector(1 downto 0);
        S_AXI_RVALID    : out std_logic;
        S_AXI_RREADY    : in std_logic
        );
    end component hc_sr04_ctrls_v1_0_S00_AXI;
    
    -- Intermediate signals
    signal echos_synced : std_logic_vector(NUM_SENSORS-1 downto 0);
    signal dists_ctrl_saxi : slv32_bus_t(NUM_SENSORS-1 downto 0);
    signal en_ctrls_saxi : std_logic_vector(NUM_SENSORS-1 downto 0);

begin

-- Instantiation of Axi Bus Interface S00_AXI
hc_sr04_ctrls_v1_0_S00_AXI_inst : hc_sr04_ctrls_v1_0_S00_AXI
    generic map (
        -- User
        NUM_SENSORS => NUM_SENSORS,
        -- User end
        C_S_AXI_DATA_WIDTH  => C_S00_AXI_DATA_WIDTH,
        C_S_AXI_ADDR_WIDTH  => C_S00_AXI_ADDR_WIDTH
    )
    port map (
        -- User
        SENSORS_EN_OUT => en_ctrls_saxi,
        DISTANCES_IN => dists_ctrl_saxi,
        -- User end
        S_AXI_ACLK  => s00_axi_aclk,
        S_AXI_ARESETN   => s00_axi_aresetn,
        S_AXI_AWADDR    => s00_axi_awaddr,
        S_AXI_AWPROT    => s00_axi_awprot,
        S_AXI_AWVALID   => s00_axi_awvalid,
        S_AXI_AWREADY   => s00_axi_awready,
        S_AXI_WDATA => s00_axi_wdata,
        S_AXI_WSTRB => s00_axi_wstrb,
        S_AXI_WVALID    => s00_axi_wvalid,
        S_AXI_WREADY    => s00_axi_wready,
        S_AXI_BRESP => s00_axi_bresp,
        S_AXI_BVALID    => s00_axi_bvalid,
        S_AXI_BREADY    => s00_axi_bready,
        S_AXI_ARADDR    => s00_axi_araddr,
        S_AXI_ARPROT    => s00_axi_arprot,
        S_AXI_ARVALID   => s00_axi_arvalid,
        S_AXI_ARREADY   => s00_axi_arready,
        S_AXI_RDATA => s00_axi_rdata,
        S_AXI_RRESP => s00_axi_rresp,
        S_AXI_RVALID    => s00_axi_rvalid,
        S_AXI_RREADY    => s00_axi_rready
    );

    -- Add user logic here
    insantiate: for i in 0 to NUM_SENSORS-1 generate
        echo_in_sync : entity work.sync_dff(rtl)
        port map (
           reset_n => s00_axi_aresetn,
           clk => s00_axi_aclk,
           async_in => echos_in(i),
           sync_out => echos_synced(i)
        );
        hc_sr04_ctrl : entity work.hc_sr04_ctrl(behavioral)
        generic map (
            CLK_FREQ_HZ => CLK_FREQ_HZ,
            D_WIDTH => C_S00_AXI_DATA_WIDTH
        )
        port map (
            reset_n => s00_axi_aresetn,
            clk => s00_axi_aclk,
            trig_out => trigs_out(i),
            echo_in => echos_synced(i),
            enable_in => en_ctrls_saxi(i),
            dist_out => dists_ctrl_saxi(i)
        );
    end generate;
    -- User logic ends

end arch_imp;
