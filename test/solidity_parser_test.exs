defmodule SolidityParserTest do
  use ExUnit.Case
  doctest SolidityParser

  test "greets the world" do
    assert SolidityParser.hello() == :world
  end
  test "parse solidity" do
   check_parse(:ok, """
      function closeAnnouncement(uint256 id) onlyOwner external {
        /*
            Close announcement. It can be closed only by those in the admin list. Windup is allowed only after the announcement is completed.

            @id     Announcement identification
        */
        require( announcements[id].open && announcements[id].end < block.number );
        if ( ! checkOpposited(announcements[id].oppositionWeight, announcements[id].oppositable) ) {
            announcements[id].result = true;
            if ( announcements[id].Type == announcementType.newModule ) {
                require( moduleHandler(moduleHandlerAddress).newModule(announcements[id]._str, announcements[id]._addr, true, true) );
            } else if ( announcements[id].Type == announcementType.dropModule ) {
                require( moduleHandler(moduleHandlerAddress).dropModule(announcements[id]._str, true) );
            } else if ( announcements[id].Type == announcementType.replaceModule ) {
                require( moduleHandler(moduleHandlerAddress).replaceModule(announcements[id]._str, announcements[id]._addr, true) );
            } else if ( announcements[id].Type == announcementType.replaceModuleHandler) {
                require( moduleHandler(moduleHandlerAddress).replaceModuleHandler(announcements[id]._addr) );
            } else if ( announcements[id].Type == announcementType.transactionFeeRate ||
                        announcements[id].Type == announcementType.transactionFeeMin ||
                        announcements[id].Type == announcementType.transactionFeeMax ||
                        announcements[id].Type == announcementType.transactionFeeBurn ) {
                require( moduleHandler(moduleHandlerAddress).configureModule("token", announcements[id].Type, announcements[id]._uint) );
            } else if ( announcements[id].Type == announcementType.providerPublicFunds ||
                        announcements[id].Type == announcementType.providerPrivateFunds ||
                        announcements[id].Type == announcementType.providerPrivateClientLimit ||
                        announcements[id].Type == announcementType.providerPublicMinRate ||
                        announcements[id].Type == announcementType.providerPublicMaxRate ||
                        announcements[id].Type == announcementType.providerPrivateMinRate ||
                        announcements[id].Type == announcementType.providerPrivateMaxRate ||
                        announcements[id].Type == announcementType.providerGasProtect ||
                        announcements[id].Type == announcementType.providerInterestMinFunds ||
                        announcements[id].Type == announcementType.providerRentRate ) {
                require( moduleHandler(moduleHandlerAddress).configureModule("provider", announcements[id].Type, announcements[id]._uint) );
            } else if ( announcements[id].Type == announcementType.schellingRoundBlockDelay ||
                        announcements[id].Type == announcementType.schellingCheckRounds ||
                        announcements[id].Type == announcementType.schellingCheckAboves ||
                        announcements[id].Type == announcementType.schellingRate ) {
                require( moduleHandler(moduleHandlerAddress).configureModule("schelling", announcements[id].Type, announcements[id]._uint) );
            } else if ( announcements[id].Type == announcementType.publisherMinAnnouncementDelay) {
                minAnnouncementDelay = announcements[id]._uint;
            } else if ( announcements[id].Type == announcementType.publisherOppositeRate) {
                oppositeRate = uint8(announcements[id]._uint);
            }
        }
        announcements[id].end = block.number;
        announcements[id].open = false;
    }
      """)
    {:ok, content} = File.read("sols/announcementTypes.sol")
    check_parse(:ok, content)
    {:ok, content} = File.read("sols/Factory.sol")
    check_parse(:ok, content)
    {:ok, content} = File.read("sols/ico.sol")
    check_parse(:ok, content)
    {:ok, content} = File.read("sols/Migrations.sol")
    check_parse(:ok, content)
    {:ok, content} = File.read("sols/MilestoneTracker.sol")
    check_parse(:ok, content)
    {:ok, content} = File.read("sols/module.sol")
    check_parse(:ok, content)
    {:ok, content} = File.read("sols/multiOwner.sol")
    check_parse(:ok, content)
    {:ok, content} = File.read("sols/MultiSigWallet.sol")
    check_parse(:ok, content)
    {:ok, content} = File.read("sols/MultiSigWalletFactory.sol")
    check_parse(:ok, content)
    {:ok, content} = File.read("sols/MultiSigWalletWithDailyLimit.sol")
    check_parse(:ok, content)
    {:ok, content} = File.read("sols/MultiSigWalletWithDailyLimitFactory.sol")
    check_parse(:ok, content)
    {:ok, content} = File.read("sols/owned.sol")
    check_parse(:ok, content)
    {:ok, content} = File.read("sols/premium.sol")
    check_parse(:ok, content)
    {:ok, content} = File.read("sols/provider.sol")
    check_parse(:ok, content)
    {:ok, content} = File.read("sols/publisher.sol")
    check_parse(:ok, content)
    {:ok, content} = File.read("sols/RLP.sol")
    check_parse(:ok, content)
    {:ok, content} = File.read("sols/safeMath.sol")
    check_parse(:ok, content)
    {:ok, content} = File.read("sols/schelling.sol")
    check_parse(:ok, content)
    {:ok, content} = File.read("sols/TestToken.sol")
    check_parse(:ok, content)
    {:ok, content} = File.read("sols/token.sol")
    check_parse(:ok, content)
    {:ok, content} = File.read("sols/tokenDB.sol")
    check_parse(:ok, content)
    # assert :ok == 1
  end


  defp check_parse(expect, str) do
    {:ok, tokens, _} = :solidity_leex.string(String.to_charlist(str))
    # IO.inspect(tokens, limit: :infinity)
    {:ok, res} = :solidity_yecc.parse(tokens)
    # IO.inspect(res, limit: :infinity)
  end
end
