a = "abis-mal aladar alcmene anda angel annette apollo atka atropos babette bagheera baker baloo bashful baylene berlioz bernard big-mama bimbette blake bolt boomer bruton buck buster calliope chaca chief clio clotho cody cogsworth colette cookie copper creeper dallben danielle demetrius denahi desoto dinky dopey doris duchess eema eeyore einstein ellie-mae eudora evinrude fa-mulan fagin faline faloo fidget flit foxy-loxy francis francois frank frou-frou gantu georgette goob grace gramps grumpy gurgi hands happy hermes hook-hand hoonah innoko jake jim-crow jock junior kaa kerchak kirby kocoum krebbs kron kuzco lady laverne lefty lewis li-shang lizzy luke madam-mim maggie mama-odie marahute marie max-hare meeko melpomene melvin mildred mindy mittens mooch morph mowgli mulan mungo mushu nakoma nanny neera nessus nita onus orville otto patch peg penny percy perdita peter-pan pinocchio plio pongo princess quasimodo razoul rhino rico rita roscoe ruby rufus sarabi sarafina sarousch scat-cat scroop shan-yu simba sir-ector sir-hiss sir-kay sis-bunny sitka sleepy smee sneezy sparky suri tanana tantor tarzan terk thug tigger tina tiny tipo tod toulouse trusty tug uncle-art victor vixey wesley wiggins wilbur winston yar yzma zephyr zeus zini".split(' ');
exports.get = () ->
	a[Math.floor(Math.random() * a.length)]