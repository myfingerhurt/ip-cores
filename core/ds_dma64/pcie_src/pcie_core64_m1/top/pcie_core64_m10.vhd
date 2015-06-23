-------------------------------------------------------------------------------
--
-- Title       : pcie_core64_m10
-- Author      : Dmitry Smekhov
-- Company     : Instrumental Systems 
-- E-mail      : dsmv@insys.ru
--
-- Version     : 1.0
--
-------------------------------------------------------------------------------
--
-- Description :  ���������� ���� PCI Express 
--				  ����������� 10 - Artix 7 PCI Express 2.0 x4 
--
-------------------------------------------------------------------------------
--
--  Version 1.0		15.08.2011 
--					������ �� pcie_core64_m4 v1.2
--
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;

use work.core64_type_pkg.all;

package	pcie_core64_m10_pkg is

--! ���������� PCI-Express 
component pcie_core64_m10 is
	generic (  
		DEVICE_ID			: in std_logic_vector := x"5507";   	--! �������� �������� DeviceID 
		refclk				: in integer:=100;				--! �������� ������� �������� ������� [���]
		is_simulation		: in integer:=0;				--! 0 - ������, 1 - ������������� 
		interrupt_number	: in std_logic_vector( 1 downto 0 ):="00"	-- ����� INTx: 0 - INTA, 1 - INTB, 2 - INTC, 3 - INTD 
		
	);		  
	
	port (
	
		---- PCI-Express ----
		txp				: out std_logic_vector( 3 downto 0 );
		txn				: out std_logic_vector( 3 downto 0 );
		
		rxp				: in  std_logic_vector( 3 downto 0 );
		rxn				: in  std_logic_vector( 3 downto 0 );
		
		mgt250			: in  std_logic; --! �������� ������� 250 MHz ��� 100 ��� �� PCI_Express
		
		perst			: in  std_logic;	--! 0 - �����						   
		
		px				: out std_logic_vector( 7 downto 0 );	--! ����������� ����� 
		
		pcie_lstatus	: out std_logic_vector( 15 downto 0 ); -- ������� LSTATUS
		pcie_link_up	: out std_logic;	-- 0 - ��������� ������������� PCI-Express
		
		
		---- ��������� ���� ----			  
		clk_out			: out std_logic;	--! �������� ������� 250 MHz		  
		reset_out		: out std_logic;	--! 0 - �����
		dcm_rstp		: out std_logic;	--! 1 - ����� DCM 266 ���

		---- BAR0 - ����� ���������� ----
		bp_host_data	: out std_logic_vector( 31 downto 0 );	--! ���� ������ - ����� 
		bp_data			: in  std_logic_vector( 31 downto 0 );  --! ���� ������ - ����
		bp_adr			: out std_logic_vector( 19 downto 0 );	--! ����� �������� 
		bp_we			: out std_logic_vector( 3 downto 0 ); 	--! 1 - ������ � �������� 
		bp_rd			: out std_logic_vector( 3 downto 0 );   --! 1 - ������ �� ��������� ����� 
		bp_sel			: out std_logic_vector( 1 downto 0 );	--! ����� ����� ��� ������ 
		bp_reg_we		: out std_logic;			--! 1 - ������ � ������� �� �������   0x100000 - 0x1FFFFF 
		bp_reg_rd		: out std_logic; 			--! 1 - ������ �� �������� �� ������� 0x100000 - 0x1FFFFF 
		bp_irq			: in  std_logic;			--! 1 - ������ ���������� 

		---- BAR1 ----	
		aclk			: in std_logic;				--! �������� ������� ��������� ���� - 266 ���
		aclk_lock		: in std_logic;				--! 1 - ������ �������
		pb_master		: out type_pb_master;		--! ������ 
		pb_slave		: in  type_pb_slave			--! �����  
		
				
		
	);
end component;

end package;



library ieee;
use ieee.std_logic_1164.all;		

use work.core64_type_pkg.all;
use work.core64_rx_engine_m2_pkg.all;
use work.core64_tx_engine_m2_pkg.all;	
use work.core64_reg_access_pkg.all;
use work.core64_pb_disp_pkg.all;   
use work.block_pe_fifo_ext_pkg.all;		
use work.core64_interrupt_pkg.all;

--! ���������� PCI-Express 
entity pcie_core64_m10 is
	generic (
		DEVICE_ID			: in std_logic_vector := x"5507";   	--! �������� �������� DeviceID 
		refclk				: in integer:=100;				--! �������� ������� �������� ������� [���]
		is_simulation		: in integer:=0;				--! 0 - ������, 1 - ������������� 
		interrupt_number	: in std_logic_vector( 1 downto 0 ):="00"	-- ����� INTx: 0 - INTA, 1 - INTB, 2 - INTC, 3 - INTD 
	);		  
	
	port (
	
		---- PCI-Express ----
		txp				: out std_logic_vector( 3 downto 0 );
		txn				: out std_logic_vector( 3 downto 0 );
		
		rxp				: in  std_logic_vector( 3 downto 0 );
		rxn				: in  std_logic_vector( 3 downto 0 );
		
		mgt250			: in  std_logic; 	--! �������� ������� 250 MHz ��� 100 ��� �� PCI_Express
		
		perst			: in  std_logic;	--! 0 - �����						   
		
		px				: out std_logic_vector( 7 downto 0 );	--! ����������� ����� 
		
		pcie_lstatus	: out std_logic_vector( 15 downto 0 ); --! ������� LSTATUS
		pcie_link_up	: out std_logic;	--! 0 - ��������� ������������� PCI-Express
		
		
		---- ��������� ���� ----			  
		clk_out			: out std_logic;	--! �������� ������� 250 MHz		  
		reset_out		: out std_logic;	--! 0 - �����
		dcm_rstp		: out std_logic;	--! 1 - ����� DCM 266 ���

		---- BAR0 - ����� ���������� ----
		bp_host_data	: out std_logic_vector( 31 downto 0 );	--! ���� ������ - ����� 
		bp_data			: in  std_logic_vector( 31 downto 0 );  --! ���� ������ - ����
		bp_adr			: out std_logic_vector( 19 downto 0 );	--! ����� �������� 
		bp_we			: out std_logic_vector( 3 downto 0 ); 	--! 1 - ������ � �������� 
		bp_rd			: out std_logic_vector( 3 downto 0 );   --! 1 - ������ �� ��������� ����� 
		bp_sel			: out std_logic_vector( 1 downto 0 );	--! ����� ����� ��� ������ 
		bp_reg_we		: out std_logic;			--! 1 - ������ � ������� �� �������   0x100000 - 0x1FFFFF 
		bp_reg_rd		: out std_logic; 			--! 1 - ������ �� �������� �� ������� 0x100000 - 0x1FFFFF 
		bp_irq			: in  std_logic;			--! 1 - ������ ���������� 

		---- BAR1 ----	
		aclk			: in std_logic;				--! �������� ������� ��������� ���� - 266 ���
		aclk_lock		: in std_logic;				--! 1 - ������ �������
		pb_master		: out type_pb_master;		--! ������ 
		pb_slave		: in  type_pb_slave			--! �����  
		
		
	);
end pcie_core64_m10;


architecture pcie_core64_m10 of pcie_core64_m10 is

function  set_refclk( refclk	: in integer ) return integer is

variable	ret	: integer;

begin

	case( refclk ) is
		when 100 =>	ret:=0; 	 	-- 100 MHz --
		when 250 => ret:=2;		-- 250 MHz --
		when others => ret:=1;	-- 125 MHz --
	end case;
	
	return ret;
	
end set_refclk;

constant	REF_CLK_FREQ		: integer:=set_refclk( refclk );

function  set_interrupt_pin( num	: in std_logic_vector( 1 downto 0 ) ) return bit_vector is

variable	ret	: bit_vector( 3 downto 0 );

begin
	
	case( num ) is
		when "00" => ret:=x"1";		-- INTA -- 
		when "01" => ret:=x"2"; 	-- INTB --
		when "10" => ret:=x"3"; 	-- INTC --
		when "11" => ret:=x"4"; 	-- INTD --
		when others => ret:=x"0"; 
	end case;
		
	return ret;	
	
end set_interrupt_pin;

constant	INTERRUPT_PIN			: bit_vector( 3 downto 0 ):=set_interrupt_pin( interrupt_number );


constant C_DATA_WIDTH				: integer:=64;

component cl_a7pcie_x4    generic (
      --CFG_VEND_ID                                : std_logic_vector := X"4953";
 	  CFG_DEV_ID                                 : std_logic_vector := X"5507";
      PL_FAST_TRAIN                              : string     := "FALSE";
      REF_CLK_FREQ                               : integer    := 0;    -- 0 - 100 MHz; 1 - 125 MHz; 2 - 250 MHz
      PCIE_EXT_CLK                               : string := "FALSE";
      UPSTREAM_FACING                            : string := "TRUE"
    );
    port (
     -------------------------------------------------------------------------------------------------------------------
     -- 1. PCI Express (pci_exp) Interface                                                                            --
     -------------------------------------------------------------------------------------------------------------------
      pci_exp_txp                                : out std_logic_vector(3 downto 0);
      pci_exp_txn                                : out std_logic_vector(3 downto 0);
      pci_exp_rxp                                : in std_logic_vector(3 downto 0);
      pci_exp_rxn                                : in std_logic_vector(3 downto 0);

     -------------------------------------------------------------------------------------------------------------------
     -- 2. Clocking Interface                                                                                         --
     -------------------------------------------------------------------------------------------------------------------
      PIPE_PCLK_IN                               : in std_logic:='0';
      PIPE_RXUSRCLK_IN                           : in std_logic:='0';
      PIPE_RXOUTCLK_IN                           : in std_logic_vector(3 downto 0):=(others=>'0');
      PIPE_DCLK_IN                               : in std_logic:='0';
      PIPE_USERCLK1_IN                           : in std_logic:='0';
      PIPE_USERCLK2_IN                           : in std_logic:='0';
      PIPE_OOBCLK_IN                             : in std_logic:='0';
      PIPE_MMCM_LOCK_IN                          : in std_logic:='0';

      PIPE_TXOUTCLK_OUT                          : out std_logic;
      PIPE_RXOUTCLK_OUT                          : out std_logic_vector(3 downto 0);
      PIPE_PCLK_SEL_OUT                          : out std_logic_vector(3 downto 0);
      PIPE_GEN3_OUT                              : out std_logic;

     -------------------------------------------------------------------------------------------------------------------
     -- 3. AXI-S Interface                                                                                            --
     -------------------------------------------------------------------------------------------------------------------
      -- Common
      user_clk_out                               : out std_logic;
      user_reset_out                             : out std_logic;
      user_lnk_up                                : out std_logic;

      -- TX
      tx_buf_av                                  : out std_logic_vector(5 downto 0);
      tx_cfg_req                                 : out std_logic;
      tx_err_drop                                : out std_logic;
      s_axis_tx_tready                           : out std_logic;
      s_axis_tx_tdata                            : in std_logic_vector((C_DATA_WIDTH - 1) downto 0);
      s_axis_tx_tkeep                            : in std_logic_vector((C_DATA_WIDTH / 8 - 1) downto 0);
      s_axis_tx_tlast                            : in std_logic;
      s_axis_tx_tvalid                           : in std_logic;
      s_axis_tx_tuser                            : in std_logic_vector(3 downto 0);
      tx_cfg_gnt                                 : in std_logic;

      -- RX
      m_axis_rx_tdata                            : out std_logic_vector((C_DATA_WIDTH - 1) downto 0);
      m_axis_rx_tkeep                            : out std_logic_vector((C_DATA_WIDTH / 8 - 1) downto 0);
      m_axis_rx_tlast                            : out std_logic;
      m_axis_rx_tvalid                           : out std_logic;
      m_axis_rx_tready                           : in std_logic;
      m_axis_rx_tuser                            : out std_logic_vector(21 downto 0);
      rx_np_ok                                   : in std_logic:='0';  -- ???
      rx_np_req                                  : in std_logic:='0';  -- ???

      -- Flow Control
      fc_cpld                                    : out std_logic_vector(11 downto 0);
      fc_cplh                                    : out std_logic_vector(7 downto 0);
      fc_npd                                     : out std_logic_vector(11 downto 0);
      fc_nph                                     : out std_logic_vector(7 downto 0);
      fc_pd                                      : out std_logic_vector(11 downto 0);
      fc_ph                                      : out std_logic_vector(7 downto 0);
      fc_sel                                     : in std_logic_vector(2 downto 0);

     -------------------------------------------------------------------------------------------------------------------
     -- 4. Configuration (CFG) Interface                                                                              --
     -------------------------------------------------------------------------------------------------------------------
     ---------------------------------------------------------------------
      -- EP and RP                                                      --
     ---------------------------------------------------------------------
      cfg_mgmt_do                                : out std_logic_vector (31 downto 0);
      cfg_mgmt_rd_wr_done                        : out std_logic;

      cfg_status                                 : out std_logic_vector(15 downto 0);
      cfg_command                                : out std_logic_vector(15 downto 0);
      cfg_dstatus                                : out std_logic_vector(15 downto 0);
      cfg_dcommand                               : out std_logic_vector(15 downto 0);
      cfg_lstatus                                : out std_logic_vector(15 downto 0);
      cfg_lcommand                               : out std_logic_vector(15 downto 0);
      cfg_dcommand2                              : out std_logic_vector(15 downto 0);
      cfg_pcie_link_state                        : out std_logic_vector(2 downto 0);

      cfg_pmcsr_pme_en                           : out std_logic;
      cfg_pmcsr_powerstate                       : out std_logic_vector(1 downto 0);
      cfg_pmcsr_pme_status                       : out std_logic;
      cfg_received_func_lvl_rst                  : out std_logic;

      -- Management Interface
      cfg_mgmt_di                                : in std_logic_vector (31 downto 0):=(others=>'0');
      cfg_mgmt_byte_en                           : in std_logic_vector (3 downto 0):=(others=>'0');
      cfg_mgmt_dwaddr                            : in std_logic_vector (9 downto 0):=(others=>'0');
      cfg_mgmt_wr_en                             : in std_logic:='0';
      cfg_mgmt_rd_en                             : in std_logic:='0';
      cfg_mgmt_wr_readonly                       : in std_logic:='0';

      -- Error Reporting Interface
      cfg_err_ecrc                               : in std_logic:='0';
      cfg_err_ur                                 : in std_logic:='0';
      cfg_err_cpl_timeout                        : in std_logic:='0';
      cfg_err_cpl_unexpect                       : in std_logic:='0';
      cfg_err_cpl_abort                          : in std_logic:='0';
      cfg_err_posted                             : in std_logic:='0';
      cfg_err_cor                                : in std_logic:='0';
      cfg_err_atomic_egress_blocked              : in std_logic:='0';
      cfg_err_internal_cor                       : in std_logic:='0';
      cfg_err_malformed                          : in std_logic:='0';
      cfg_err_mc_blocked                         : in std_logic:='0';
      cfg_err_poisoned                           : in std_logic:='0';
      cfg_err_norecovery                         : in std_logic:='0';
      cfg_err_tlp_cpl_header                     : in std_logic_vector(47 downto 0):=(others=>'0');
      cfg_err_cpl_rdy                            : out std_logic;
      cfg_err_locked                             : in std_logic:='0';
      cfg_err_acs                                : in std_logic:='0';
      cfg_err_internal_uncor                     : in std_logic:='0';
      cfg_trn_pending                            : in std_logic:='0';
      cfg_pm_halt_aspm_l0s                       : in std_logic:='0';
      cfg_pm_halt_aspm_l1                        : in std_logic:='0';
      cfg_pm_force_state_en                      : in std_logic:='0';
      cfg_pm_force_state                         : in std_logic_vector(1 downto 0):=(others=>'0');
      cfg_dsn                                    : in std_logic_vector(63 downto 0):=(others=>'0');

     ---------------------------------------------------------------------
      -- EP Only                                                        --
     ---------------------------------------------------------------------
      cfg_interrupt                              : in std_logic;
      cfg_interrupt_rdy                          : out std_logic;
      cfg_interrupt_assert                       : in std_logic;
      cfg_interrupt_di                           : in std_logic_vector(7 downto 0);
      cfg_interrupt_do                           : out std_logic_vector(7 downto 0);
      cfg_interrupt_mmenable                     : out std_logic_vector(2 downto 0);
      cfg_interrupt_msienable                    : out std_logic;
      cfg_interrupt_msixenable                   : out std_logic;
      cfg_interrupt_msixfm                       : out std_logic;
      cfg_interrupt_stat                         : in std_logic:='0';
      cfg_pciecap_interrupt_msgnum               : in std_logic_vector(4 downto 0):=(others=>'0');	  
      cfg_to_turnoff                             : out std_logic;
      cfg_turnoff_ok                             : in std_logic:='0';
      cfg_bus_number                             : out std_logic_vector(7 downto 0);
      cfg_device_number                          : out std_logic_vector(4 downto 0);
      cfg_function_number                        : out std_logic_vector(2 downto 0);
      cfg_pm_wake                                : in std_logic:='0';

     ---------------------------------------------------------------------
      -- RP Only                                                        --
     ---------------------------------------------------------------------
      cfg_pm_send_pme_to                         : in std_logic:='0';
      cfg_ds_bus_number                          : in std_logic_vector(7 downto 0):=(others=>'0');
      cfg_ds_device_number                       : in std_logic_vector(4 downto 0):=(others=>'0');
      cfg_ds_function_number                     : in std_logic_vector(2 downto 0):=(others=>'0');

      cfg_mgmt_wr_rw1c_as_rw                     : in std_logic:='0';
      cfg_msg_received                           : out std_logic;
      cfg_msg_data                               : out std_logic_vector(15 downto 0);

      cfg_bridge_serr_en                         : out std_logic;
      cfg_slot_control_electromech_il_ctl_pulse  : out std_logic;
      cfg_root_control_syserr_corr_err_en        : out std_logic;
      cfg_root_control_syserr_non_fatal_err_en   : out std_logic;
      cfg_root_control_syserr_fatal_err_en       : out std_logic;
      cfg_root_control_pme_int_en                : out std_logic;
      cfg_aer_rooterr_corr_err_reporting_en      : out std_logic;
      cfg_aer_rooterr_non_fatal_err_reporting_en : out std_logic;
      cfg_aer_rooterr_fatal_err_reporting_en     : out std_logic;
      cfg_aer_rooterr_corr_err_received          : out std_logic;
      cfg_aer_rooterr_non_fatal_err_received     : out std_logic;
      cfg_aer_rooterr_fatal_err_received         : out std_logic;

      cfg_msg_received_err_cor                   : out std_logic;
      cfg_msg_received_err_non_fatal             : out std_logic;
      cfg_msg_received_err_fatal                 : out std_logic;
      cfg_msg_received_pm_as_nak                 : out std_logic;
      cfg_msg_received_pm_pme                    : out std_logic;
      cfg_msg_received_pme_to_ack                : out std_logic;
      cfg_msg_received_assert_int_a              : out std_logic;
      cfg_msg_received_assert_int_b              : out std_logic;
      cfg_msg_received_assert_int_c              : out std_logic;
      cfg_msg_received_assert_int_d              : out std_logic;
      cfg_msg_received_deassert_int_a            : out std_logic;
      cfg_msg_received_deassert_int_b            : out std_logic;
      cfg_msg_received_deassert_int_c            : out std_logic;
      cfg_msg_received_deassert_int_d            : out std_logic;
      cfg_msg_received_setslotpowerlimit         : out std_logic;

     -------------------------------------------------------------------------------------------------------------------
     -- 5. Physical Layer Control and Status (PL) Interface                                                           --
     -------------------------------------------------------------------------------------------------------------------
      pl_directed_link_change                    : in std_logic_vector(1 downto 0):="00";
      pl_directed_link_width                     : in std_logic_vector(1 downto 0):="00";
      pl_directed_link_speed                     : in std_logic:='0';
      pl_directed_link_auton                     : in std_logic:='0';
      pl_upstream_prefer_deemph                  : in std_logic:='0';

      pl_sel_lnk_rate                            : out std_logic;
      pl_sel_lnk_width                           : out std_logic_vector(1 downto 0);
      pl_ltssm_state                             : out std_logic_vector(5 downto 0);
      pl_lane_reversal_mode                      : out std_logic_vector(1 downto 0);

      pl_phy_lnk_up                              : out std_logic;
      pl_tx_pm_state                             : out std_logic_vector(2 downto 0);
      pl_rx_pm_state                             : out std_logic_vector(1 downto 0);

      pl_link_upcfg_cap                          : out std_logic;
      pl_link_gen2_cap                           : out std_logic;
      pl_link_partner_gen2_supported             : out std_logic;
      pl_initial_link_width                      : out std_logic_vector(2 downto 0);

      pl_directed_change_done                    : out std_logic;

     ---------------------------------------------------------------------
      -- EP Only                                                        --
     ---------------------------------------------------------------------
      pl_received_hot_rst                        : out std_logic;
     ---------------------------------------------------------------------
      -- RP Only                                                        --
     ---------------------------------------------------------------------
      pl_transmit_hot_rst                        : in std_logic:='0';
      pl_downstream_deemph_source                : in std_logic:='0';
     -------------------------------------------------------------------------------------------------------------------
     -- 6. AER interface                                                                                              --
     -------------------------------------------------------------------------------------------------------------------
      cfg_err_aer_headerlog                      : in std_logic_vector(127 downto 0):=(others=>'0');
      cfg_aer_interrupt_msgnum                   : in std_logic_vector(4 downto 0):=(others=>'0');
      cfg_err_aer_headerlog_set                  : out std_logic;
      cfg_aer_ecrc_check_en                      : out std_logic;
      cfg_aer_ecrc_gen_en                        : out std_logic;
     -------------------------------------------------------------------------------------------------------------------
     -- 7. VC interface                                                                                               --
     -------------------------------------------------------------------------------------------------------------------
      cfg_vc_tcvc_map                            : out std_logic_vector(6 downto 0);

     -------------------------------------------------------------------------------------------------------------------
     -- 8. System(SYS) Interface                                                                                      --
     -------------------------------------------------------------------------------------------------------------------
      PIPE_MMCM_RST_N                            : in std_logic;   --     // Async      | Async
      sys_clk                                    : in std_logic;
      sys_rst_n                                  : in std_logic);
  end component;

--signal     sys_clk_c : std_logic;

--signal     sys_reset_n_c : std_logic;
signal     trn_clk_c : std_logic;
signal     user_reset 		: std_logic;
signal     user_lnk_up 		: std_logic;
signal     cfg_trn_pending_n_c : std_logic;
signal     trn_tsof_n_c : std_logic;
signal     trn_teof_n_c : std_logic;
signal     trn_tsrc_rdy_n_c : std_logic;
signal     trn_tdst_rdy_n_c : std_logic;
signal     trn_tsrc_dsc_n_c : std_logic;
signal     trn_terrfwd_n_c : std_logic;
signal     trn_tdst_dsc_n_c : std_logic;
signal     trn_td_c : std_logic_vector((64 - 1) downto 0);
signal     trn_trem_n_c : std_logic_vector(7 downto 0);
signal     trn_tbuf_av_c : std_logic_vector(( 4 -1 )  downto 0);
signal     trn_rsof_n_c : std_logic;
signal     trn_reof_n_c : std_logic;
signal     trn_rsrc_rdy_n_c : std_logic;
signal     trn_rsrc_dsc_n_c : std_logic;
signal     trn_rdst_rdy_n_c : std_logic;
signal     trn_rerrfwd_n_c : std_logic;
signal     trn_rnp_ok_n_c : std_logic;

signal     trn_rd_c : std_logic_vector((64 - 1) downto 0);
signal     trn_rrem_n_c : std_logic_vector(7 downto 0);
signal     trn_rbar_hit_n_c : std_logic_vector(6 downto 0);
signal     trn_rfc_nph_av_c : std_logic_vector(7 downto 0);
signal     trn_rfc_npd_av_c : std_logic_vector(11 downto 0);
signal     trn_rfc_ph_av_c : std_logic_vector(7 downto 0);
signal     trn_rfc_pd_av_c : std_logic_vector(11 downto 0);
signal     trn_rcpl_streaming_n_c      : std_logic;

signal     cfg_do : std_logic_vector(31 downto 0);
signal     cfg_di : std_logic_vector(31 downto 0);
signal     cfg_dwaddr : std_logic_vector(9 downto 0) ;
signal     cfg_byte_en : std_logic_vector(3 downto 0);
signal     cfg_err_tlp_cpl_header : std_logic_vector(47 downto 0);
signal     cfg_wr_en : std_logic;
signal     cfg_rd_en : std_logic;
signal     cfg_rd_wr_done : std_logic;
signal     cfg_err_cor : std_logic;
signal     cfg_err_ur : std_logic;
signal     cfg_err_ecrc : std_logic;
signal     cfg_err_cpl_timeout : std_logic;
signal     cfg_err_cpl_abort : std_logic;
signal     cfg_err_cpl_unexpect : std_logic;
signal     cfg_err_posted : std_logic;	 
signal		cfg_err_locked	: std_logic;  
signal	    cfg_trn_pending                           : std_logic;
signal	    cfg_dcommand2                             : std_logic_vector(15 downto 0);
signal      cfg_dsn                                   : std_logic_vector(63 downto 0);


signal      pl_initial_link_width                     : std_logic_vector(2 downto 0);
signal      pl_lane_reversal_mode                     : std_logic_vector(1 downto 0);
signal      pl_link_gen2_capable                      : std_logic;
signal      pl_link_partner_gen2_supported            : std_logic;
signal      pl_link_upcfg_capable                     : std_logic;
signal      pl_ltssm_state                            : std_logic_vector(5 downto 0);
signal      pl_received_hot_rst                       : std_logic;
signal      pl_sel_link_rate                          : std_logic;
signal      pl_sel_link_width                         : std_logic_vector(1 downto 0);
signal      pl_directed_link_auton                    : std_logic;
signal      pl_directed_link_change                   : std_logic_vector(1 downto 0);
signal      pl_directed_link_speed                    : std_logic;
signal      pl_directed_link_width                    : std_logic_vector(1 downto 0);
signal      pl_upstream_prefer_deemph                 : std_logic;



signal     cfg_err_cpl_rdy : std_logic;  
signal     cfg_interrupt : std_logic;
signal     cfg_interrupt_rdy : std_logic;

signal     cfg_interrupt_assert : std_logic;

signal     cfg_interrupt_n 			: std_logic;
signal     cfg_interrupt_rdy_n	 	: std_logic;
signal     cfg_interrupt_assert_n	: std_logic;


signal     cfg_interrupt_di : std_logic_vector(7 downto 0);
signal     cfg_interrupt_do : std_logic_vector(7 downto 0);
signal     cfg_interrupt_mmenable : std_logic_vector(2 downto 0);
signal     cfg_interrupt_msienable: std_logic;

signal     cfg_turnoff_ok : std_logic;
signal     cfg_to_turnoff : std_logic;
signal     cfg_pm_wake : std_logic;
signal     cfg_pcie_link_state : std_logic_vector(2 downto 0);
signal     cfg_bus_number : std_logic_vector(7 downto 0);
signal     cfg_device_number : std_logic_vector(4 downto 0);
signal     cfg_function_number : std_logic_vector(2 downto 0);
signal     cfg_status : std_logic_vector(15 downto 0);
signal     cfg_command : std_logic_vector(15 downto 0);
signal     cfg_dstatus : std_logic_vector(15 downto 0);
signal     cfg_dcommand : std_logic_vector(15 downto 0);
signal     cfg_lstatus : std_logic_vector(15 downto 0);
signal     cfg_lcommand : std_logic_vector(15 downto 0);
--signal     unsigned_fast_simulation: unsigned(0 downto 0);
signal     vector_fast_simulation: std_logic_vector(0 downto 0):=(0=>'1');

signal	fc_sel				: std_logic_vector( 2 downto 0 );	   
signal	sys_reset_p			: std_logic;

signal	refclkout			: std_logic;


signal clk					: std_logic;
signal rstp					: std_logic;
signal trn_rx				: type_axi_rx;			--! ���� ������
signal trn_rx_back			: type_axi_rx_back;		--! ���������� � ����� ������

signal reg_access			: type_reg_access;		--! ������ �� ������ � ��������� 
		
signal rx_tx_engine			: type_rx_tx_engine;	--! ����� RX->TX 
signal tx_rx_engine			: type_tx_rx_engine;	--! ����� TX->RX 
		
signal rx_ext_fifo			: type_rx_ext_fifo;		--! ����� RX->EXT_FIFO 
signal tx_ext_fifo			: type_tx_ext_fifo;
signal	tx_ext_fifo_back	: type_tx_ext_fifo_back;
signal	reg_access_back		: type_reg_access_back;
signal	completer_id		: std_logic_vector( 15 downto 0 );

signal	trn_tx				: type_axi_tx;
signal	trn_tx_back			: type_axi_tx_back;

signal	reg_disp			: type_reg_disp;
signal	reg_disp_back		: type_reg_disp_back;

signal	reg_ext_fifo		: type_reg_ext_fifo;
signal	reg_ext_fifo_back	: type_reg_ext_fifo_back;

signal	ext_fifo_disp		: type_ext_fifo_disp;		--! ������ �� ������ �� ���� EXT_FIFO 
signal	ext_fifo_disp_back	: type_ext_fifo_disp_back;	--! ����� �� ������

signal	pb_rstp				: std_logic;

signal	irq					: std_logic;

function  SET_FAST_TRAIN( is_simulation : integer ) return string is

constant	ret_true	: string:="TRUE";	
constant	ret_false	: string:="FALSE";

begin			   
	
	if( is_simulation=0 ) then
		return ret_false;
	else
		return ret_true;
	end if;
		
end SET_FAST_TRAIN;

constant	PL_FAST_TRAIN	: string:= SET_FAST_TRAIN( is_simulation );

begin


	
clk_out <= clk;
reset_out <= not pb_rstp after 1 ns when rising_edge( clk );

ep :  cl_a7pcie_x4  
  generic map(
  	 CFG_DEV_ID						=> DEVICE_ID,
     REF_CLK_FREQ                   => REF_CLK_FREQ,           -- 0 - 100 MHz; 1 - 125 MHz; 2 - 250 MHz
  	 PL_FAST_TRAIN					=> PL_FAST_TRAIN
--	 INTERRUPT_PIN                  => INTERRUPT_PIN,
-- 	 PCIE_CAP_INT_MSG_NUM          	=> INTERRUPT_PIN
	   
  )
  port map(
	  pci_exp_txp                     => txp,
	  pci_exp_txn                     => txn,
	  pci_exp_rxp                     => rxp,
	  pci_exp_rxn                     => rxn,
	  user_clk_out                    => clk ,
	  user_reset_out                  => user_reset,
	  user_lnk_up                     => user_lnk_up,
	  tx_buf_av                       => trn_tx_back.trn_tbuf_av ,
	  tx_cfg_req                      => trn_tx_back.tx_cfg_req ,
	  tx_err_drop                     => trn_tx_back.tx_err_drop ,
	  s_axis_tx_tready                => trn_tx_back.s_axis_tx_tready ,
	  s_axis_tx_tdata                 => trn_tx.s_axis_tx_tdata ,
	  s_axis_tx_tkeep                 => trn_tx.s_axis_tx_tstrb ,
	  s_axis_tx_tlast                 => trn_tx.s_axis_tx_tlast ,
	  s_axis_tx_tvalid                => trn_tx.s_axis_tx_tvalid ,
	  s_axis_tx_tuser                 => trn_tx.s_axis_tx_tuser,
	  tx_cfg_gnt                      => trn_tx.tx_cfg_gnt ,
	  m_axis_rx_tdata                 => trn_rx.m_axis_rx_tdata ,
	  m_axis_rx_tkeep                 => trn_rx.m_axis_rx_tstrb ,
	  m_axis_rx_tlast                 => trn_rx.m_axis_rx_tlast ,
	  m_axis_rx_tvalid                => trn_rx.m_axis_rx_tvalid ,
	  m_axis_rx_tready                => trn_rx_back.m_axis_rx_tready ,
	  m_axis_rx_tuser                 => trn_rx.m_axis_rx_tuser,
	  rx_np_ok                        => trn_rx_back.rx_np_ok ,
	  fc_cpld                         => trn_tx_back.fc_cpld ,
	  fc_cplh                         => trn_tx_back.fc_cplh ,
	  fc_npd                          => trn_tx_back.fc_npd ,
	  fc_nph                          => trn_tx_back.fc_nph ,
	  fc_pd                           => trn_tx_back.fc_pd ,
	  fc_ph                           => trn_tx_back.fc_ph ,
	  fc_sel                          => trn_tx.fc_sel ,

	  cfg_interrupt                   => cfg_interrupt ,
	  cfg_interrupt_rdy               => cfg_interrupt_rdy ,
	  cfg_interrupt_assert            => cfg_interrupt_assert ,
	  cfg_interrupt_di                => cfg_interrupt_di ,
	  cfg_interrupt_do                => cfg_interrupt_do ,
	  cfg_interrupt_mmenable          => cfg_interrupt_mmenable ,
	  cfg_interrupt_msienable         => cfg_interrupt_msienable ,
	  cfg_turnoff_ok                  => cfg_turnoff_ok ,
	  cfg_to_turnoff                  => cfg_to_turnoff ,
	  cfg_trn_pending                 => cfg_trn_pending ,
	  cfg_pm_wake                     => cfg_pm_wake ,
	  cfg_bus_number                  => cfg_bus_number ,
	  cfg_device_number               => cfg_device_number ,
	  cfg_function_number             => cfg_function_number ,
	  cfg_status                      => cfg_status ,
	  cfg_command                     => cfg_command ,
	  cfg_dstatus                     => cfg_dstatus ,
	  cfg_dcommand                    => trn_tx_back.cfg_dcommand  ,
	  cfg_lstatus                     => cfg_lstatus ,
	  cfg_lcommand                    => cfg_lcommand ,
	  cfg_dcommand2                   => cfg_dcommand2 ,
	  cfg_pcie_link_state             => cfg_pcie_link_state ,
	  cfg_dsn                         => cfg_dsn ,
	  cfg_pmcsr_pme_en                => open,
	  cfg_pmcsr_pme_status            => open,
	  cfg_pmcsr_powerstate            => open,
	  
	  PIPE_MMCM_RST_N				  =>  '1',
	  sys_clk                         =>  mgt250,
	  sys_rst_n                       =>  perst
	
);

sys_reset_p <= not perst;

pcie_link_up <= not user_lnk_up;
pcie_lstatus <= cfg_lstatus;

rstp <=  user_reset  after 1 ns when rising_edge( clk );
dcm_rstp <= user_reset;

pb_rstp <= rstp or ( not aclk_lock ) after 1 ns when rising_edge( clk );

--trn_tx_back.cfg_dcommand <= cfg_dcommand;
--  trn_rnp_ok_n_c              <= '0';
--  trn_rcpl_streaming_n_c      <= '1'; 
--  trn_terrfwd_n_c             <= '1';
--
--  cfg_err_cor             <= '1';
--  cfg_err_ur              <= '1';
--  cfg_err_ecrc            <= '1';
--  cfg_err_cpl_timeout     <= '1';
--  cfg_err_cpl_abort       <= '1';
--  cfg_err_cpl_unexpect    <= '1';
--  cfg_err_posted          <= '0';
--
--  cfg_interrupt_di <= X"00";
--
--  cfg_pm_wake             <= '1';
--  cfg_trn_pending         <= '1';
--  cfg_dwaddr                <= (others => '0');
--  cfg_err_tlp_cpl_header    <= (others => '0');
--  cfg_di                    <= (others => '0');
--  cfg_byte_en             <= X"F"; -- 4-bit bus
--  cfg_wr_en               <= '1';
--  cfg_rd_en               <= '1';	 
  
  fc_sel             <= "000";

--  rx_np_ok           <= '1';
--
--  tx_cfg_gnt         <= '1';
--
  cfg_err_cor          <= '0';
  cfg_err_ur           <= '0';
  cfg_err_ecrc         <= '0';
  cfg_err_cpl_timeout  <= '0';
  cfg_err_cpl_abort    <= '0';
  cfg_err_cpl_unexpect <= '0';
  cfg_err_posted       <= '0';
  cfg_err_locked       <= '0';
  cfg_pm_wake          <= '0';
  cfg_trn_pending      <= '0';

--  trn_tx.s_axis_tx_tuser(0)   <= '0'; -- Unused for S6
--  trn_tx.s_axis_tx_tuser(1)   <= '0'; -- Error forward packet
--  trn_tx.s_axis_tx_tuser(2)   <= '0'; -- Stream packet
                 
--  cfg_interrupt_assert <= '0';
--  cfg_interrupt        <= '0';
  cfg_interrupt_di     <= x"00";

  cfg_err_tlp_cpl_header <= (OTHERS => '0');
  cfg_dwaddr             <= (OTHERS => '0');
  cfg_rd_en            <= '0';
  cfg_wr_en            <= '0';
  cfg_byte_en          <= X"0";
  cfg_di               <= (others => '0');
  cfg_dsn              <= (others=>'0');
  

--  cfg_completer_id     <= (cfg_bus_number &
--                           cfg_device_number &
--                           cfg_function_number);
--  cfg_bus_mstr_enable  <= cfg_command(2);

  pl_directed_link_auton  <= '0';
  pl_directed_link_speed  <= '0';
  pl_directed_link_width  <= "00";
  pl_directed_link_change <= "00";
  pl_upstream_prefer_deemph <= '1';  
  
--  cfg_completer_id_c          <= (cfg_bus_number &
--                                cfg_device_number &
--                                cfg_function_number);
--  cfg_bus_mstr_enable_c       <= cfg_command(2);



rx: core64_rx_engine_m2
	port map(
	
		--- General ---
		rstp			=> rstp,			--! 1 - ����� 
		clk				=> clk,				--! �������� ������� ���� - 250 MHz 
		
		trn_rx			=> trn_rx,			--! ���� ������
		trn_rx_back		=> trn_rx_back,		--! ���������� � ����� ������
						                
		reg_access		=> reg_access,		--! ������ �� ������ � ��������� 
						                
		rx_tx_engine	=> rx_tx_engine,	--! ����� RX->TX 
		tx_rx_engine	=> tx_rx_engine,	--! ����� TX->RX 
						                
		rx_ext_fifo		=> rx_ext_fifo		--! ����� RX->EXT_FIFO 
		
		
		
	);
	

tx: core64_tx_engine_m2 
	generic map(
		interrupt_number		=> interrupt_number		-- ����� INTx: 0 - INTA, 1 - INTB, 2 - INTC, 3 - INTD 
	)
	port map(
	
		--- General ---
		rstp			=> rstp,			--! 1 - ����� 
		clk				=> clk,				--! �������� ������� ���� - 250 MHz 
		
		trn_tx			=> trn_tx,			--! �������� ������
		trn_tx_back		=> trn_tx_back,		--! ���������� � �������� ������
						                
		completer_id	=> completer_id,	--! ������������� ���������� 
		
		--cfg_interrupt			=> cfg_interrupt_n, 		-- 0 - ��������� ��������� ����������
		--cfg_interrupt_assert	=> cfg_interrupt_assert_n,	-- 0 - ������������ ����������, 1 - ������ ���������� 
		--cfg_interrupt_rdy		=> cfg_interrupt_rdy_n,		-- 0 - ������������� ��������� ���������� 

		cfg_interrupt			=> '1', 		-- 0 - ��������� ��������� ����������
		cfg_interrupt_assert	=> '1',			-- 0 - ������������ ����������, 1 - ������ ���������� 
		--cfg_interrupt_rdy		=> cfg_interrupt_rdy_n,		-- 0 - ������������� ��������� ���������� 
		
		reg_access_back	=> reg_access_back,	--! ������ �� ������ � ��������� 
						                
		rx_tx_engine	=> rx_tx_engine,	--! ����� RX->TX 
		tx_rx_engine	=> tx_rx_engine,	--! ����� TX->RX 
						                
		tx_ext_fifo		=> tx_ext_fifo,		--! ����� TX->EXT_FIFO 
		tx_ext_fifo_back=> tx_ext_fifo_back --! ����� TX->EXT_FIFO 
			
	);
	
  completer_id     <= (cfg_bus_number &
                       cfg_device_number &
                       cfg_function_number );	
					   
					   
 reg: core64_reg_access 
	port map(
		--- General ---
		rstp				=> rstp,	--! 1 - ����� 
		clk					=> clk,		--! �������� ������� ���� - 250 MHz 
		
		--- RX_ENGINE ---- 
		reg_access			=> reg_access,	--! ������ �� ������ � ��������� 
		
		--- TX_ENGINE ----
		reg_access_back		=> reg_access_back,	--! ����� �� ������ 
		
		---- PB_DISP ----
		reg_disp			=> reg_disp,		--! ������ �� ������ � ��������� �� BAR1 
		reg_disp_back		=> reg_disp_back,	--! ����� �� ������ 
		
		---- BLOCK EXT_FIFO ----
		reg_ext_fifo		=> reg_ext_fifo,		--! ������ �� ������ � ������ ���������� EXT_FIFO 
		reg_ext_fifo_back	=> reg_ext_fifo_back,	--! ����� �� ������ 
		
		---- BAR0 - ����� ���������� ----
		bp_host_data		=> bp_host_data,	--! ���� ������ - ����� 
		bp_data				=> bp_data,			--! ���� ������ - ����
		bp_adr				=> bp_adr,			--! ����� �������� 
		bp_we				=> bp_we,			--! 1 - ������ � �������� 
		bp_rd				=> bp_rd,			--! 1 - ������ �� ��������� ����� 
		bp_sel				=> bp_sel,			--! ����� ����� ��� ������ 
		bp_reg_we			=> bp_reg_we,		--! 1 - ������ � ������� �� �������   0x100000 - 0x1FFFFF 
		bp_reg_rd			=> bp_reg_rd,		--! 1 - ������ �� �������� �� ������� 0x100000 - 0x1FFFFF 
		bp_irq				=> bp_irq			--! 1 - ������ ���������� 
	);					   

	
 disp: core64_pb_disp 
	port map(
		--- General ---
		rstp				=> pb_rstp,		--! 1 - ����� 
		clk					=> clk,			--! �������� ������� ���� - 250 MHz 
		
		---- PB_DISP ----
		reg_disp			=> reg_disp,		--! ������ �� ������ � ��������� �� BAR1 
		reg_disp_back		=> reg_disp_back,	--! ����� �� ������ 
		
		---- EXT_FIFO ----
		ext_fifo_disp		=> ext_fifo_disp,		--! ������ �� ������ �� ���� EXT_FIFO 
		ext_fifo_disp_back	=> ext_fifo_disp_back,	--! ����� �� ������
		
		---- BAR1 ----	
		aclk				=> aclk,				--! �������� ������� ��������� ���� - 266 ���
		pb_master			=> pb_master,			--! ������ 
		pb_slave			=> pb_slave				--! �����  

	);	
	


fifo: block_pe_fifo_ext 
	port map(
	
		---- Global ----	 
		rstp				 => pb_rstp,				 
		clk					 => clk,					 
		aclk				 => aclk,				 
							                      
		---- TX_ENGINE ----	 
		tx_ext_fifo			 => tx_ext_fifo,			 
		tx_ext_fifo_back	 => tx_ext_fifo_back,	 
							                      
		---- RX_ENGINE ----	 
		rx_ext_fifo			 => rx_ext_fifo,
							                      
		---- REG ----		 
		reg_ext_fifo		 => reg_ext_fifo,		 
		reg_ext_fifo_back	 => reg_ext_fifo_back, 
							 	                 
		---- DISP  ----		 
		ext_fifo_disp		 => ext_fifo_disp,
		ext_fifo_disp_back	 => ext_fifo_disp_back,
		
		irq					 => irq,				-- 1 - ������ ����������
		
		test				=> px
	);
		
	
 

 int: core64_interrupt 
	port map(
	
		rstp					=> pb_rstp,					-- 1 - �����
		clk						=> clk,						-- �������� ������� ���� 250 ���
		
		irq						=> irq,						-- 1 - ������ ����������
		
		cfg_command10			=> cfg_command(10),			-- 1 - ���������� ��������� 
		cfg_interrupt			=> cfg_interrupt_n, 		-- 0 - ��������� ��������� ����������
		cfg_interrupt_assert	=> cfg_interrupt_assert_n,	-- 0 - ������������ ����������, 1 - ������� ���������� 
		cfg_interrupt_rdy		=> cfg_interrupt_rdy_n		-- 0 - ������������� ��������� ���������� 
	
	);											   
	
cfg_interrupt <= not cfg_interrupt_n;	
cfg_interrupt_assert <= not cfg_interrupt_assert_n;
cfg_interrupt_rdy_n <= not cfg_interrupt_rdy;	

--cfg_interrupt <= '0';
--cfg_interrupt_assert <= '0';
--	cfg_interrupt_n_c <= '1';
--	cfg_interrupt_assert_n_c <= '1';
	
end pcie_core64_m10;
