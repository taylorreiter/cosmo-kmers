'''
Author: Taylor Reiter & Phillip Brooks
Affiliation: UC Davis Lab for Data Intensive Biology
Aim: A Snakemake workflow to compute and classify sourmash signatures
Run: snakemake --use-conda
'''

import os

SAMPLES = ['HSMA33OT',
'CSM9X233',
'CSM5MCWG',
'MSMAPC7P',
'CSM9X23H',
'CSM79HLM',
'CSM79HNK',
'HSM7J4NY',
'MSM6J2QD',
'HSM7CZ1Z',
'MSM79HA1',
'MSM9VZIQ',
'MSMA26EH',
'CSM67UEA',
'HSM67VFJ',
'CSM7KOPI',
'HSMA33IO',
'HSM7J4IS',
'CSM79HLC',
'CSM67UDJ',
'HSM7CZ2E',
'CSM7KOP8',
'MSM79H89',
'ESM7F5CF',
'PSM7J12F',
'CSM67U9J',
'CSM9X23N',
'CSM79HIN',
'PSMA266M',
'CSM7KOTQ',
'CSM79HLI',
'MSM9VZFN',
'MSM6J2HR',
'MSM9VZNZ',
'HSM67VDZ',
'HSM5MD6A',
'HSM6XRVA',
'HSMA33J9',
'PSM6XBSM',
'MSM9VZF5',
'HSM7J4NE',
'CSM7KOL2',
'PSMB4MC1',
'MSMA26BT',
'CSM67UB9',
'MSM6J2QB',
'MSM79HAR',
'HSM7J4QJ',
'CSM5MCY2',
'HSM7J4OX',
'HSM6XRV2',
'HSM7J4JN',
'HSMA33MX',
'HSM6XRSE',
'MSMAPC59',
'PSM7J18I',
'MSM6J2HT',
'HSMA33NO',
'MSM9VZFT',
'MSM9VZNR',
'CSM67UC6',
'MSM79HF7',
'MSM6J2J5',
'CSM7KOK5',
'ESM7F5AM',
'HSM6XRQS',
'HSMA33SG',
'PSM7J16H',
'HSMA33PZ',
'CSM7KOOT',
'HSM7J4HE',
'HSM7CYZ9',
'PSM7J1B9',
'HSMA33J7',
'MSM6J2JD',
'MSM9VZHF',
'PSM7J13Q',
'HSM6XRQU',
'HSM7CYYP',
'HSM7J4PO',
'MSM6J2IY',
'PSM7J1AU',
'HSMA33KQ',
'ESM7F5C7',
'MSM9VZL9',
'PSM6XBUM',
'HSMA33JD',
'MSM6J2K8',
'PSM7J14L',
'CSM67UAW',
'HSM7CYY5',
'MSM6J2RA',
'PSM6XBV2',
'PSM7J12J',
'CSM79HHA',
'CSM7KORO',
'CSM67UBF',
'PSM6XBUI',
'MSM9VZMC',
'CSM79HR2',
'MSMB4LZ8',
'PSMA265D',
'MSMB4LZR',
'HSM67VEO',
'HSM7CYY3',
'PSM7J15Q',
'PSM6XBT1',
'CSM5MCXD',
'CSM7KOOH',
'CSM7KOKB',
'HSM6XRR9',
'HSM6XRS4',
'HSMA33IS',
'PSM7J15I',
'CSM79HJM',
'CSM7KOKZ',
'HSM7J4NC',
'PSM7J12V',
'HSMA33JZ',
'MSMAPC5L',
'HSM6XRUV',
'CSM67UAY',
'MSM9VZNX',
'MSM6J2J1',
'CSM5MCVN',
'MSM9VZIY',
'MSM5LLF6',
'PSM7J1CI',
'MSM79HAN',
'PSMA2653',
'MSM79HBB',
'HSM7J4OL',
'MSM6J2LJ',
'HSMA33OV',
'HSMA33NC',
'PSM6XBSU',
'CSM7KOTC',
'PSM7J1AW',
'CSM5FZ4M',
'HSM67VEI',
'CSM67UF5',
'HSMA33QO',
'MSMA26BB',
'CSM7KOOD',
'CSM7KOMH',
'HSM7J4JH',
'MSM9VZNL',
'PSM7J14N',
'HSM67VHW',
'CSM5MCYS',
'CSM7KOMZ',
'HSMA33KM',
'ESM7F5CB',
'PSM7J19F',
'HSM7CZ18',
'HSM6XRUX',
'PSMA265T',
'CSM7KON2',
'CSM79HM1',
'CSM67UE7',
'HSM6XRSN',
'MSM9VZEK',
'HSMA33IC',
'PSM7J19P',
'ESM5MEDD',
'MSM79HBR',
'MSMA26BL',
'MSM6J2RO',
'HSMA33JR',
'PSM7J1CU',
'PSM7J19H',
'MSM79HAH',
'CSM5MCZ3',
'HSM7J4LD',
'PSM7J12B',
'MSM9VZHT',
'CSM67UDY',
'PSM6XBTX',
'MSM79H8H',
'MSM9VZEU',
'MSM6J2LL',
'HSMA33RF',
'HSMA33RT',
'CSM9X1XU',
'PSMA269S',
'MSM6J2R2',
'HSM7CYZV',
'HSM6XRVM',
'HSM7J4KM',
'HSM67VD2',
'MSM6J2KM',
'PSM7J17B',
'HSM7CZ36',
'HSM7J4PI',
'PSM7J1DF',
'MSMA26DM',
'HSM7J4O9',
'CSMAAEUA',
'MSM5LLEP',
'ESM5MED2',
'ESM718TF',
'CSM79HH8',
'MSMA26AP',
'PSM7J15S',
'CSM79HPA_TR',
'HSM7J4G8',
'HSMA33LB',
'CSM7KOPG',
'MSM79HB6',
'HSM7J4PU',
'CSM79HH4',
'HSM7J4IW',
'CSM7KOLA',
'MSM6J2HN',
'MSM5LLDE',
'HSM7J4N4',
'HSM67VI5',
'HSMA33LJ',
'PSM7J14X',
'HSM7J4JF',
'MSM9VZOW',
'CSM79HHU',
'CSM79HQ9',
'HSM7J4KI',
'CSM79HNO',
'MSM79H7O',
'CSM7KOKF',
'HSM67VHJ',
'MSM6J2HB',
'MSM6J2PS',
'PSM6XBVS',
'CSMACTZP',
'CSM9X215',
'HSM5MD41',
'MSM9VZHN',
'ESM5MEC3',
'CSM79HN2',
'HSM6XRSX',
'PSMA267P',
'HSM7CYZL',
'HSM7CZ32',
'HSM6XRUR',
'HSM6XRQB',
'CSM67UDF',
'CSM7KOUN',
'HSM6XRR7',
'HSM7J4KA',
'HSM7CZ3C',
'CSM79HGX',
'PSM6XBVO',
'ESM718SY',
'MSM9VZMI',
'MSM79HES',
'MSM6J2JR',
'MSMA26DK',
'CSM79HPO',
'MSM79HCR',
'MSM6J2IO',
'HSM7CZ2H',
'MSM6J2SI',
'MSM79HDM',
'PSM7J173',
'HSM6XRTG',
'HSM7J4HQ',
'MSM9VZLF',
'CSM7KOKD',
'HSM7J4N6',
'CSM7KORI',
'MSMB4LYH',
'HSM6XRV6',
'MSM5LLDM',
'HSM7J4HM',
'MSM5LLF8',
'HSMA33MS',
'HSMA33OX',
'HSMA33JN',
'CSM79HJS',
'PSM6XBVQ',
'HSMA33OJ',
'HSM6XRQM',
'HSM7J4PA',
'MSM6J2Q5',
'HSM7CYXQ',
'MSMA26AL',
'PSM7J12R',
'HSM7CYXO',
'HSMA33O3',
'CSM67UAO',
'CSM67U9D',
'HSM5MD73',
'HSMA33R9',
'MSM5LLDQ',
'MSMB4LZK',
'MSM79HF9_TR',
'HSM6XRS6',
'MSM6J2II',
'MSM9VZI6',
'CSM5MCVL',
'MSM9VZGO',
'MSM6J2MF',
'HSM6XRVC',
'PSM6XBSI',
'HSM5MD7K',
'HSM5MD66',
'CSM67UDR_TR',
'HSMA33MK',
'MSM79H85',
'PSM7J193',
'CSM9X235',
'MSM9VZEO',
'CSM79HKV',
'ESM5MEC9',
'MSM9VZIM',
'CSMAHYLR',
'MSMA26DG',
'MSM9VZMU',
'PSMA269G',
'MSM6J2RM',
'HSM7CYZJ',
'HSM6XRQ8',
'MSMAPC5D',
'MSM79H83',
'HSMA33R7',
'CSM7KONA',
'PSM6XBVI',
'CSM79HOL',
'HSMA33PN',
'CSM7KOSX',
'CSM9X1YV',
'CSM5MCXR',
'CSM79HP2',
'CSM67UGC',
'CSM67UFZ',
'PSMA265J_TR',
'HSM7CZ3E',
'HSM5MD7J',
'HSM6XRT8',
'MSM6J2HJ',
'HSM6XRVO',
'HSM7J4IU',
'HSM7J4GP',
'ESM5MEBI',
'HSM67VHH',
'HSM5MD4O',
'MSMA26BF',
'PSM6XBTP',
'HSM67VEE',
'ESM718V8',
'CSM79HIJ',
'HSM7CYXI',
'MSMA26EP',
'ESM5MEC5',
'CSM9X21R',
'CSM5MCZB',
'HSM7J4O7',
'CSM7KOJQ',
'PSMA263W',
'HSM7CYX8',
'MSMA26BX',
'MSM9VZOG',
'HSMA33OR',
'MSMAPC7J',
'MSM6J2QP',
'MSM5LLER',
'CSM9X21N',
'CSM67UBX',
'PSM7J129',
'PSMA264U',
'MSM5LLDS',
'CSM79HOT',
'HSM5MD48',
'MSM79H9M',
'MSM9VZF7',
'MSM79HA7',
'HSM7J4R2',
'HSM7J4G1',
'CSM7KOPU',
'MSMAPC64',
'MSM9VZEY',
'HSM6XRQI',
'MSM6J2HH',
'HSMA33S4',
'HSM5MD62',
'HSM5MD3Y',
'PSM6XBTT',
'MSM6J2PU',
'CSM79HIT',
'HSM7CYYB',
'CSM67UAK',
'PSM6XBVK',
'MSM6J2RQ',
'MSMA26EJ',
'HSM67VI3',
'HSMA33IK',
'CSM7KOSV',
'CSM79HI3',
'MSM6J2LR',
'MSM79H9Y',
'MSM79H9W',
'PSM7J182',
'PSM7J4EF',
'CSM79HLK',
'CSM7KOQX',
'HSM67VHD',
'PSM7J1BP',
'HSM7J4OZ',
'MSMA26AZ_TR',
'MSM6J2K4',
'CSMAF72L',
'HSM7J4MK',
'PSM6XBV4',
'MSM79H7Q',
'MSMAPC55',
'MSM9VZPN',
'MSMA26DO',
'MSM79HDQ_TR',
'MSM79HDG',
'PSM6XBT3',
'HSM7J4OE',
'CSM79HRC',
'CSM7KOJE',
'MSMAPC6E',
'CSM79HKB',
'ESM5MEBS',
'HSM6XRSI',
'MSM7J16N',
'CSM7KOSL',
'MSM6J2JT',
'HSM7J4O3',
'MSM9VZHL',
'MSM79HDU',
'CSMA88CB',
'CSM7KOLK',
'CSM67UEI',
'CSM9X22U',
'PSM6XBTL',
'HSM7J4MC',
'HSM67VEC',
'PSM7J1B7',
'MSM79HBN',
'HSM7J4OV',
'HSM67VFF',
'MSM9VZES',
'CSM79HMP',
'HSM7J4J9',
'PSM7J1BR',
'CSM67UF1',
'MSM9VZIS',
'HSM67VGG',
'ESM7F5AK',
'MSM79HCP',
'HSM7CYXC',
'MSMAPC6A',
'HSM5MD6Y',
'MSM7J16R',
'HSM6XRTM',
'CSM7KOTU',
'MSM6J2KA',
'PSMA2668',
'PSMA267J',
'CSM67UA2',
'CSM79HLG',
'CSM79HNW',
'MSM9VZEK_TR',
'MSM79HDO',
'MSM6J2QL',
'PSMB4MBS',
'CSM67UBH',
'CSM67UAS',
'CSM79HIH',
'MSM5LLDC',
'HSM6XRRD',
'CSM7KORC',
'HSMA33IG',
'ESM718TK',
'HSMA33KO',
'MSMB4LXY',
'HSM7J4JZ',
'CSM5MCXJ',
'PSM7J1A2',
'HSM7J4M6',
'HSM7J4JD',
'CSM7KOOZ',
'PSM6XBUG',
'PSM7J1C8',
'MSM79H6D',
'CSM7KOS7',
'HSM5MD79',
'MSMB4LZV',
'PSM6XBT5',
'CSM67UB3',
'MSM6J2QR',
'MSM79HAJ',
'HSM7CYXA',
'PSM6XBSO',
'CSM79HGF',
'HSM7J4Q9',
'MSM6J2RC',
'MSM79HDK',
'MSM79H5U',
'MSMA26CX',
'MSMA26EL',
'CSM7KORK',
'CSM79HPK',
'MSM79HFW',
'HSM67VFH',
'HSMA33PX',
'HSM7J4QF',
'ESM5GEXY',
'HSM5FZBZ',
'PSMA265H',
'MSM79H54',
'ESM718TM',
'HSM6XRRB',
'HSMA33SE',
'HSM6XRUL',
'HSM7J4K6',
'CSM9X21J',
'HSM7J4KG',
'MSM9VZHJ',
'MSM6J2RS',
'HSM7J4MY',
'MSMA26AR',
'HSM67VF3',
'MSMA26BH',
'MSM6J2JZ',
'HSM7J4QH',
'HSM67VI1',
'MSM79H9Q',
'HSM7J4L5',
'CSM79HIL',
'MSM6J2PW',
'HSM7J4K8',
'MSM79HDS',
'PSM7J12D',
'MSM9VZF1',
'HSMA33OL',
'HSMA33RX_TR',
'CSM7KONK',
'MSM9VZMM',
'CSM7KOP2',
'MSMB4LXS',
'CSM7KOOR',
'MSM79H81',
'HSM6XRRV',
'MSM6J2K6',
'CSM9X22I',
'CSM67UCK',
'CSM7KOMT',
'MSMA267V',
'PSM6XBUQ',
'PSM7J19J',
'MSM6J2JB',
'CSM7KOPW',
'PSM7J158',
'MSMA26ER',
'HSMA33QY',
'CSM7KOPM',
'MSM79HBZ',
'HSM7CYZB',
'HSM6XRVC_TR',
'CSM79HJW',
'MSM9VZHR',
'MSM79H5S',
'CSM7KORM',
'HSM7CYZ7',
'HSM67VIB',
'HSM7J4HI',
'MSM9VZOI',
'MSM6J2LN',
'HSM67VFR',
'MSM6J2PK',
'HSM7CZ14',
'CSM79HJO',
'HSM7CZ1V',
'PSMA265L',
'CSM5MCZ5',
'MSM5LLDA',
'MSM6J2PM',
'HSM6XRTS',
'HSM7J4I7',
'MSM6J2Q1',
'MSM9VZMW',
'PSM7J1AQ',
'CSM67UAQ',
'PSMA264S',
'CSM79HPC',
'CSM79HQZ',
'HSM67VEK',
'MSM79HBV',
'MSM79HEA',
'CSM79HK9',
'CSM79HIX',
'HSM5MD4Y',
'HSM5MD5P',
'MSM9VZL5',
'HSM7J4NO',
'CSM67UBR',
'HSM7CYXS',
'PSM7J16B',
'PSM6XBS8',
'PSM6XBR1',
'CSM5MCWE',
'HSMA33IE',
'MSMAPC66',
'CSM67UEM',
'CSM9X21T',
'PSM7J14T',
'CSM7KOJY',
'MSM6J2QJ',
'MSM79H9A',
'HSM5MD5B',
'HSM7J4GR',
'MSM79H8B',
'CSM79HRE',
'MSM79HDC',
'HSM5MD6M',
'HSM6XRVK',
'HSM7CZ28',
'HSM7J4I5',
'HSMA33KE',
'PSM6XBSU_TR',
'HSM7J4RE',
'HSM6XRTO',
'CSM79HJY',
'HSM7CYZT',
'MSM9VZIO',
'MSM6J2JN',
'PSM7J17T',
'HSM6XRQK',
'HSM67VEW',
'CSM7KOPO',
'MSM9VZLH',
'CSM79HOF',
'PSMA264W',
'MSM9VZLT',
'MSM6J2LW',
'CSM7KOK1',
'HSM67VHQ',
'MSM9VZLD',
'CSM7KOOV',
'PSM7J1BJ',
'MSM79HC8',
'HSMA33M8',
'MSMA26AX',
'HSM67VFX',
'HSM7J4HG',
'HSMA33MZ',
'HSMA33M2',
'CSM9X22K',
'MSM79HDQ',
'CSM67U9H',
'HSM7J4QL',
'HSM5MD7O',
'HSM67VHK',
'HSM7J4MW',
'CSM67UAU',
'HSM7CYY9',
'PSM6XBUK',
'MSM9VZOU',
'PSM7J17F',
'MSM5LLDK',
'MSM6J2MH',
'CSM9X222',
'CSM67UDR',
'PSMA26A3',
'PSMA263M',
'HSM7J4PG',
'PSM7J136',
'MSM6J2OL',
'MSMA26BR',
'HSM7J4PK',
'CSM79HOZ',
'PSM7J15G',
'HSMA33MV',
'MSM6J2LT',
'HSMA33KU',
'HSM6XRV8',
'PSM7J1A8',
'PSM7J15M',
'MSM9VZLZ',
'MSMA2684',
'MSM9VZO2',
'HSM6XRRJ',
'HSM67VGA',
'MSM79HEY',
'CSM79HQV',
'MSM79HAT',
'HSM7J4P2',
'CSM7KOOF',
'PSMA267F',
'MSM9VZOM',
'PSM6XBUO',
'MSM9VZJB',
'HSM7J4NS',
'CSM79HM7',
'HSM7J4OP',
'PSMA264Q',
'MSM79HBT',
'MSM9VZGW',
'HSM7J4L9',
'CSM67UBN',
'HSMA33LZ',
'MSM79HDA',
'HSM7J4M8',
'ESM5MEBG',
'PSM6XBSS',
'PSM7J1A6',
'ESM718T9',
'CSM9X1Y3',
'HSM6XRS8',
'CSM7KOON',
'MSM6J2LY',
'CSM9X237',
'MSM9VZEW',
'PSM6XBW3',
'MSM79HDI',
'HSM7J4HY',
'PSM6XBRK_TR',
'HSM5MD7U',
'HSMA33ME',
'CSM67UAM',
'MSM5LLF4',
'HSM7CYX6',
'MSM6J2IG',
'HSM67VGC',
'MSM6J2LH',
'HSM7CZ3A',
'MSM5LLDU',
'MSM6J2KE',
'PSM7J156',
'PSMA265N',
'MSM9VZFL',
'HSMA33PL',
'HSM7J4ON',
'PSM6XBSA',
'HSM7CZ38',
'CSM7KOOJ',
'MSM6J2IQ',
'CSM79HNU',
'PSM7J169',
'HSM6XRQY',
'PSM7J1C4',
'PSMA269O',
'CSM7KOOX',
'CSM67U9N',
'PSM6XBQS',
'PSM7J18Q',
'MSM6J2SK',
'CSM7KOU9',
'MSMA26BN',
'MSM79H69',
'HSM7J4PQ',
'CSM9X1ZO',
'CSMA8M9R',
'HSM67VEM',
'HSM7J4KC',
'MSMB4LZX',
'MSM9VZKE',
'MSM79H87',
'MSM6J2ON',
'HSM7CZ1C',
'CSM67UB1',
'HSM5MD4N',
'HSM6XRVW',
'CSM67UDN',
'CSM5MCY4',
'HSM67VCZ',
'CSM7KOPS',
'MSM79H63',
'MSMB4LZZ',
'MSM9VZJ3',
'CSM79HOV',
'CSM79HIZ',
'HSM7J4PE',
'MSM9VZGS',
'CSM7KOJO',
'MSM9VZLR',
'CSM7KON8',
'PSM6XBT7',
'CSM79HL4',
'MSM79H98',
'MSM9VZJZ',
'PSMA263U',
'HSM5MD6I',
'HSM7J4J7',
'CSM79HID',
'HSM6XRUZ',
'PSMA266C',
'HSM7J4IR',
'PSMA266U',
'HSM7J4HW',
'MSM79H7W',
'MSM79HCG',
'HSM7J4LH',
'CSMAG78W',
'HSM7CZ16',
'HSM7J4M4',
'HSM67VID',
'PSM6XBS4',
'ESM718UH',
'CSM79HI7',
'MSM79H7C',
'MSMAPC6K',
'HSM7CYXE',
'PSM6XBT9',
'MSM9VZL7',
'CSM67U9B',
'CSM79HLA_TR',
'CSM7KOOL',
'HSM67VD4',
'CSM79HRG',
'CSM79HKZ',
'PSMB4MC5',
'PSM7J17V',
'MSM6J2LV',
'HSM7CZ26',
'MSM6J2K2',
'CSM7KOUB',
'PSMA265B',
'CSM79HQF',
'HSMA33LX',
'ESM7F5CD',
'HSM7J4GD',
'ESM5MEDN',
'ESM5MEB7',
'CSM7KOP6',
'CSM79HQB',
'MSM79H6F',
'CSM5MCXT',
'HSMA33MA',
'MSM79HC4',
'HSMA33MI',
'CSM7KOST',
'MSMAPC6M',
'HSM67VH1',
'MSMAPC5H',
'PSM7J19B',
'MSM79H65',
'CSM7KOMP',
'HSM7J4IC',
'MSM79HEU',
'HSM67VGK',
'PSMA2659',
'MSMAPC5Z',
'HSM7J4QT',
'HSM7CYYH',
'MSM79HDG_TR',
'CSM7KOOP',
'HSM5MD7M',
'PSM7J1BH',
'CSM79HGZ',
'CSM7KOK3',
'PSM7J16U',
'CSM7KOO9',
'PSM6XBTB',
'ESM5MEDK',
'HSM67VDP',
'MSM6J2Q3',
'CSM79HHM',
'MSM9VZGU',
'CSM7KOR2',
'HSM7J4HU',
'HSMA33J3',
'MSMAPC6G',
'PSMB4MC7',
'MSM9VZOO',
'HSM6XRQO',
'CSMAE44D',
'PSM7J18E',
'HSMA33LP',
'MSM9VZFF',
'CSM79HOX',
'CSM79HJU',
'PSM7J19T',
'PSMA266Q',
'HSM7CYYF',
'CSM7KOLM',
'HSM67VG8',
'PSMA267H',
'PSM7J15K',
'CSMAH393',
'MSM9VZFR',
'ESM5MEBE',
'CSM79HOH',
'CSM5MCWQ',
'HSMA33NY',
'CSM7KOPK',
'PSMA265J',
'CSMAIG7X',
'MSM6J2OH',
'CSM79HO1',
'HSM5MD71',
'MSM79HEW',
'PSM7J161',
'PSM7J13M',
'CSM79HLE',
'CSM7KOTK',
'MSM9VZMA_TR',
'HSM5MD6Q',
'CSM9X213',
'PSM7J17Z',
'PSM7J163',
'MSM79H8L',
'CSM9X1Z4',
'MSM6J2RK',
'PSM7J18G',
'HSM7J4MA',
'HSMA33SK',
'MSM6J2HP',
'PSM7J19R',
'MSM79HF9',
'MSM79H6B',
'HSM7J4OB',
'HSM67VIF',
'PSM7J1BD',
'CSM7KOO5',
'HSM7CZ24',
'MSM79HBP',
'HSM5MD6W',
'PSM7J15O',
'PSMA26A1',
'HSM67VE4',
'MSM79H67',
'MSM9VZIU',
'PSM6XBSE',
'PSM7J1BL',
'PSM7J13Y',
'PSM6XBRK',
'CSM7KOMB',
'MSM9VZGY',
'HSM7J4JP',
'HSM7J4LP',
'CSM9X1ZC',
'CSM79HJQ',
'MSM6J2MJ',
'MSM6J2OJ',
'HSM7J4QZ',
'PSMA2671',
'PSM7J127',
'CSM7KOSP',
'HSMA33N4',
'CSM9X1ZY',
'MSMB4LXW',
'HSM7J4IP',
'HSMA33P6',
'PSM7J1BB',
'HSMA33IA',
'HSM7J4OT',
'HSM67VD6',
'HSM7CYZD',
'CSM79HIR',
'PSM7J15W',
'MSMB4LZ4',
'ESM5MECQ',
'CSM79HMN',
'CSM67UG8',
'MSM9VZOK',
'HSM7CZ2A',
'PSM7J19N',
'HSM7J4QB',
'HSMA33Q6',
'MSM5LLDI',
'CSM5MCX3',
'MSM79HCK',
'MSMA26BV',
'CSM5MCZD',
'MSMA26BD',
'CSM67UAA',
'MSM79H5A',
'HSM5MD6C',
'MSM9VZLV',
'CSM5MCWC',
'HSMA33QM',
'MSM79H8N',
'HSM67VDT',
'MSM9VZI2',
'HSMA33RD',
'CSM5MCXN',
'HSM7CYYD',
'PSM7J1AO',
'MSM79HF5',
'CSM7KOKR',
'HSM7CYZF',
'PSMA267D',
'MSM9VZMA',
'HSM7J4PS',
'PSM7J13E',
'PSM7J154',
'CSM67UE3',
'CSM79HP4',
'HSM5MD6A_TR',
'CSM7KOL4',
'MSM9VZPH',
'MSMA26AT',
'MSM9VZNH',
'MSMAPC6O',
'MSM9VZMO',
'PSM7J199',
'CSM79HLA',
'MSM9VZHP',
'MSM9VZKC',
'HSM7J4MS',
'PSMA269W',
'CSM79HPS',
'MSM6J2MB',
'CSM5MCYW',
'MSM79H8F',
'MSM9VZLJ',
'CSM79HPU',
'CSM7KOSJ',
'HSM6XRSG',
'HSM7CYZ5',
'CSM5MCZ7',
'HSM7CYX4',
'MSM9VZOQ',
'MSM79HAL',
'HSM67VF9',
'MSM6J2R8',
'CSM9X1Y5',
'HSM67VIL',
'MSM79H7E',
'PSM7J179',
'PSM6XBSK',
'CSM67UFV',
'MSM6J2OP',
'HSM67VFD',
'MSM6J2SE',
'ESM5MEDU',
'MSMA267X',
'MSM6J2LB',
'CSM7KOPE',
'MSM79HBL',
'MSMA26ET',
'CSM67UAG',
'HSMA33O1',
'HSM7CZ1G',
'MSM79H7Y',
'HSM67VHB',
'HSMA33JP',
'PSM7J15U',
'HSMA33R1',
'MSMA26EZ',
'CSM7KOJW',
'PSMB4MC3',
'MSM9VZEM',
'HSMA33OP',
'MSM6J2J3',
'HSM5MD7S',
'PSMA267R',
'HSM7J4HS',
'MSM9VZHZ',
'HSMA33MC',
'MSM6J2HL',
'HSM7J4KO',
'HSM6XRUN',
'MSM6J2Q7',
'MSMA26AN',
'CSM7KOJU',
'HSM7CZ22',
'MSM79H6H',
'MSMAPC5B',
'MSMA2688',
'HSM6XRV4',
'PSM7J16F',
'HSM6XRST',
'HSMA33R5',
'MSM6J2IK',
'CSM79HNI',
'MSM9VZNH_TR',
'HSMA33SI',
'MSM79H9C',
'PSM7J17X',
'HSM7J4PW',
'HSM7J4PY',
'CSM7KORU',
'ESM5MECL',
'MSMA26AZ',
'MSM9VZLL',
'MSM79H9K',
'MSM6J2KC',
'HSM67VEQ',
'MSM79H6N',
'HSM7J4LN',
'CSM79HGP',
'PSMA264O',
'PSMA265X',
'PSM6XBU2',
'PSM7J171',
'MSM9VZH7',
'PSM7J14R',
'HSMA33RX',
'MSM9VZIW',
'HSM5MD7Q',
'MSM79H6Y',
'HSM7CZ2Z',
'PSM7J17D',
'HSM7J4Q1',
'MSM6J2QH',
'MSM79H6J',
'CSM7KOKN',
'MSM9VZP1',
'HSM7J4O5',
'PSMB4MBK',
'HSM7J4KQ',
'MSM7J16P',
'PSM6XBQU',
'CSM79HR4',
'HSM7J4QD',
'HSM67VHF',
'HSM7J4HO',
'MSMB4LZP',
'CSM79HKT',
'HSM5MD75',
'HSM7CYXG',
'CSM79HIV',
'HSM7J4IO',
'CSM5MCXV',
'ESM7F5C5',
'HSM5MD53',
'MSM6J2HD',
'HSM7CYX2',
'CSM7KOSH',
'HSM5MD43',
'MSM6J2IM',
'HSM67VES',
'CSM9X22S',
'HSM7J4K4',
'MSM5LLHC',
'PSM7J141',
'CSM79HMT',
'HSM7J4N8',
'CSM79HNE',
'PSM7J17L',
'HSM67VHS',
'CSM9X211',
'ESM5ME9U',
'CSM9X21L',
'MSM79HA3',
'HSM7J4NU',
'CSM9X23B',
'MSMAPC7R',
'MSM9VZKI',
'HSM7J4HA',
'HSM6XRVU',
'MSM6J2IE',
'PSM7J1AS',
'MSM9VZLN',
'CSM7KOTS',
'MSM9VZOY',
'PSM7J1BV',
'MSM79H5K',
'CSM67UBB',
'MSMA26BJ',
'MSM6J2JP',
'MSM9VZME',
'MSM9VZMS',
'MSM9VZPT',
'CSM79HOJ',
'CSM79HG5',
'MSMA26EN',
'PSM7J16Y',
'CSM7KOLE',
'MSM9VZEQ',
'HSMA33LH',
'HSM7CZ1A',
'PSM7J14P',
'ESM718T7',
'HSM7J4K2',
'CSM7KOTA',
'CSM79HNM',
'PSM7J13K',
'CSM5MCXL',
'MSM6J2QF',
'PSM7J177',
'MSM79H5Y',
'CSM7KOMX',
'CSM79HIF',
'MSM9VZOS',
'CSM79HHW',
'PSMA266Y',
'CSM67UGO',
'HSMA33OD',
'PSM7J186',
'MSMA26DI',
'MSM79H5E',
'PSM7J1CG',
'CSM5MCUO',
'CSM9X22G',
'HSM6XRQW',
'HSM7J4ME',
'CSM7KOJG',
'CSM79HJA',
'CSM7KOKT',
'CSM79HR8',
'CSM79HL6',
'CSM7KOQ1',
'CSM5MCXP',
'MSM7J16L',
'MSM6J2MD',
'PSM7J1CC',
'CSMA9J65',
'CSM7KOTO',
'HSM5MD6K',
'HSM7J4KK',
'HSM6XRR3',
'CSM7KOKJ',
'HSM67VEU',
'HSM67VEM_TR',
'PSMA266I',
'CSM7KORG',
'HSM7J4O1',
'MSM9VZF3',
'PSM7J13I',
'CSM79HP6',
'HSM7J4PM',
'HSM6XRTQ',
'HSM7J4HK',
'MSM79HDE',
'MSM9VZFH',
'PSM7J18M',
'HSMA33NW',
'MSM6J2M3',
'HSMA33OZ',
'CSM7KOJS',
'PSM7J19Z',
'PSM7J12Z',
'MSM79HFB',
'CSM79HN6',
'MSM9VZLP',
'HSM67VGK_TR',
'MSMA26CV',
'CSM5MCXH',
'HSM7J4HC',
'HSM7J4IQ',
'HSMA33L1',
'MSM79H5Q',
'HSMA33MG',
'HSM7J4LF',
'PSM6XBTD',
'MSM6J2Q9',
'MSM79H9G',
'MSM6J2PO',
'HSMA33NA',
'PSMA266O',
'CSM67UH7',
'MSM79H58',
'MSM79H5M',
'PSM7J1DL',
'CSM9X1ZQ',
'PSM6XBVM',
'HSM7J4PC',
'PSM6XBQY',
'MSM79HF3',
'CSM67UBZ',
'HSM7J4I9',
'MSM79HCI',
'MSM79H8D',
'HSM67VFZ',
'CSM5MCY8',
'HSM5MD5D',
'CSM5MCW6',
'PSM7J1BX',
'PSMA263S',
'MSM9VZHB',
'HSM7CYY7',
'HSMA33LH_TR',
'PSM7J1AM',
'PSMA264K',
'HSM67VEG',
'MSM6J2RU',
'PSM6XBQY_TR',
'PSMA265F',
'MSM9VZHX',
'PSM6XBTR',
'MSM79H5G',
'MSMAPC7T',
'CSM7KORS',
'CSM7KOK7',
'MSM6J2ML',
'HSM7CZ3G',
'MSM9VZLB',
'PSM7J1BF',
'CSM67UEW_TR',
'CSM5MCZF',
'HSMA33JB',
'HSM6XRS2',
'CSM7KOUL',
'MSMAPC6C',
'MSM9VZP3',
'HSM7J4JJ',
'MSMAPC57',
'CSM7KOLY',
'PSMA2675',
'MSMB4LYB',
'HSMA33KS',
'PSM7J15A',
'ESM5MEBU',
'ESM5MEDF',
'MSM79H7M',
'CSM79HQX',
'HSM7CYZR',
'HSMA33RR',
'MSM79H6L',
'PSM7J16W',
'MSM6J2HF',
'CSM9X219',
'HSM7J4NM',
'HSM7J4I3',
'PSM7J1A4',
'HSM7J4Q7',
'MSM7J16J',
'MSMB4LZC',
'CSM67UEW',
'MSM5LLGL',
'MSM79HFY',
'HSM7CZ1E',
'CSM7KONU',
'CSM79HR6',
'CSM79HKX',
'ESM718V4',
'HSM67VGY',
'HSM7J4NA',
'HSM6XRR5',
'MSM9VZPL',
'PSM7J184',
'CSM79HHO',
'PSMB4MBI',
'CSM79HIB',
'MSM79H7G',
'HSM67VI7',
'HSMA33J5',
'PSM7J18K',
'CSM79HPA',
'ESM9IEP1',
'HSMA33NQ',
'HSM67VI9',
'MSMA26AV']

###############################################################################
## Download DBs and scripts
###############################################################################

rule download_genbank:
    output: "inputs/databases/genbank-d2-k51.tar.gz"
    params: 
        link="https://s3-us-west-2.amazonaws.com/sourmash-databases/genbank-d2-k51.tar.gz"
    message: '--- download and unpack gather databases.'
    shell:'''
    wget -O {output} {params.link}
    '''

rule untar_genbank:
    output: "inputs/databases/genbank-d2-k51.sbt.json"
    input: "inputs/databases/genbank-d2-k51.tar.gz"
    params: outdir="inputs/databases"
    shell:'''
    tar xf {input} -C {params.outdir}
    '''

rule download_pasolli:
    output: "inputs/databases/pasolli-mags-k51.tar.gz"
    params: 
        link= 'https://osf.io/pm5qb/download'
    shell:'''
    wget -O {output} {params.link}
    '''

rule untar_pasolli:
    output: "inputs/databases/pasolli-mags-k51.sbt.json"
    input: "inputs/databases/pasolli-mags-k51.tar.gz"
    params: outdir="inputs/databases"
    shell:'''
    tar xf {input} -C {params.outdir}
    '''

rule download_almeida:
    output: "inputs/databases/almeida-mags-k51.tar.gz"
    params: 
        link= 'https://osf.io/9uq4m/download'
    shell:'''
    wget -O {output} {params.link}
    '''

rule untar_almeida:
    output: "inputs/databases/almeida-mags-k51.sbt.json"
    input: "inputs/databases/almeida-mags-k51.tar.gz"
    params: outdir="inputs/databases"
    shell:'''
    tar xf {input} -C {params.outdir}
    '''

rule download_nayfach:
    output: "inputs/databases/nayfach-mags-k51.tar.gz"
    params: 
        link= 'https://osf.io/k35sb/download'
    shell:'''
    wget -O {output} {params.link}
    '''

rule untar_nayfach:
    output: "inputs/databases/nayfach-k51.sbt.json"
    input: "inputs/databases/nayfach-mags-k51.tar.gz"
    params: outdir="inputs/databases"
    shell:'''
    tar xf {input} -C {params.outdir}
    '''

rule download_human_genome_sig:
    output: 'inputs/databases/GRCh38.p13_genomic.sig'
    shell:'''
    wget -O {output} https://osf.io/fxup3/download 
    '''

rule download_human_rna_sig:
    output: 'inputs/databases/GRCh38_rna.sig'
    shell:'''
    wget -O {output} https://osf.io/anj6b/download 
    '''

rule download_cosmo_kmer_script:
    output: 'scripts/hashes-to-numpy-2.py'
    shell: '''
    wget -O {output} https://raw.githubusercontent.com/ctb/2017-sourmash-revindex/4c9abba665c14aefe6f3cc4755bffecf9352417f/hashes-to-numpy-2.py
    '''

###############################################################################
## Metatranscriptomes (MTX)
###############################################################################

subworkflow data_snakefile:
    snakefile: "snakefiles/data.snakefile"

rule calculate_signatures:
    input: data_snakefile('inputs/data/{sample}.fastq.gz')
    output: sig = 'outputs/sigs/{sample}.scaled2k.sig'
    message: '--- Compute sourmash sigs using quality trimmed data.'
    conda: 'env.yml'
#    benchmark: 'benchmarks/{sample}.compute.benchmark.txt'
    shell:'''
    sourmash compute -o {output.sig} --scaled 2000 -k 21,31,51 --track-abundance {input}
    '''

rule gather_genbank:
    input: 
        sig = 'outputs/sigs/{sample}.scaled2k.sig',
        db = 'inputs/databases/genbank-d2-k51.sbt.json'
    output:
        gather = 'outputs/gather/genbank/{sample}.gather',
        matches = 'outputs/gather/matches/{sample}.matches', 
        un = 'outputs/gather/unassigned/{sample}.un'
    message: '--- Classify signatures with gather.'
    conda: 'env.yml'
#    benchmark: 'benchmarks/{sample}.gather.benchmark.txt'
    shell:'''
    sourmash gather -o {output.gather} --save-matches {output.matches} --output-unassigned {output.un} --scaled 2000 -k 51 {input.sig} {input.db}
    '''

rule gather_human_dbs:
    input:
        sig = 'outputs/gather/unassigned/{sample}.un',
        db1 = 'inputs/databases/pasolli-mags-k51.sbt.json',
        db2 = 'inputs/databases/almeida-mags-k51.sbt.json',
        db3 = 'inputs/databases/nayfach-k51.sbt.json'
    output:
        gather = 'outputs/gather_human_micro/gather/{sample}.gather',
        matches = 'outputs/gather_human_micro/matches/{sample}.matches',
        un = 'outputs/gather_human_micro/unassigned/{sample}.un'
    message: '--- Classify signatures with gather using Pasolli, Almeida, and Nayfach dbs.'
    conda: 'env.yml'
#    benchmark: 'benchmarks/{sample}.gather_human_dbs.benchmark.txt'
    shell:'''
    sourmash gather -o {output.gather} --save-matches {output.matches} --output-unassigned {output.un} --scaled 2000 -k 51 {input.sig} {input.db1} {input.db2} {input.db3}
    '''

rule gather_human_rna:
    input:
        sig = 'outputs/gather_human_micro/unassigned/{sample}.un',
        db1 = 'inputs/databases/GRCh38_rna.sig'
    output:
        gather = 'outputs/gather_human_rna/gather/{sample}.gather',
        matches = 'outputs/gather_human_rna/matches/{sample}.matches',
        un = 'outputs/gather_human_rna/unassigned/{sample}.un'
    message: '--- Classify signatures with gather using human rna'
    conda: 'env.yml'
#    benchmark: 'benchmarks/{sample}.gather_human_dbs.benchmark.txt'
    shell:'''
    sourmash gather -o {output.gather} --save-matches {output.matches} --output-unassigned {output.un} --scaled 2000 -k 51 {input.sig} {input.db1}
    '''

rule calc_cosmo_kmers_mtx:
# This rule requires a script from github repo ctb/2017-sourmash-revindex.
    input: 
        un=expand('outputs/gather_human_rna/unassigned/{sample}.un', sample = SAMPLES),
        script = 'scripts/hashes-to-numpy-2.py'
    output: 
        comp="outputs/cosmo/hmp_2k_t138_mtx",
        labels="outputs/cosmo/hmp_2k_t138_mtx.labels.txt"
    message: '--- Calculate cosmopolitan k-mers from unassigned hashes'
#    benchmark: 'benchmarks/calc_cosmo_kmers.benchmark.txt'
    conda:'env.yml'
    shell:'''
    {input.script} -o {output.comp} -k 51 --threshold=138 --scaled 2000 {input.un} 
    '''

#rule hashval_query_r1_mtx:
## this rule currently uses conda env sgc_hq, as that's where hashval_query
## is enabled. Bcalm has also been exported to path prior to starting snakefile.
#    input: 
#        conf = "inputs/conf/{sample}_r1_conf.yml",
#        fastq = "inputs/data/{sample}.fastq.gz",
#        cosmo = "outputs/cosmo/hmp_2k_t138_mtx.labels.txt"
#    output: "{sample}_k31_r1_hashval_k51/hashval_results.csv"
#    message: '--- Extract nbhds of cosmopolitan k-mers from each sample'
#    shell:'''
#    python -m spacegraphcats --nolock {input.conf} hashval_query
#    python -m spacegraphcats --nolock {input.conf} extract_reads_for_hashvals
#    '''   

checkpoint hashval_query_r1_mtx:
# this rule currently uses conda env sgc_hq, as that's where hashval_query
# is enabled. Bcalm has also been exported to path prior to starting snakefile.
    input: 
        conf = "inputs/conf/{sample}_r1_conf.yml",
        fastq = "inputs/data/{sample}.fastq.gz",
        cosmo = "outputs/cosmo/hmp_2k_t138_mtx.labels.txt"
    output: directory("{sample}_k31_r1_hashval_k51")
    message: '--- Extract nbhds of cosmopolitan k-mers from each sample'
    shell:'''
    python -m spacegraphcats --nolock {input.conf} hashval_query
    python -m spacegraphcats --nolock {input.conf} extract_reads_for_hashvals
    '''   
 
#def aggregate_for_megahit(wildcards):
#    hashvals = []
#    for s in SAMPLES:
#        checkpoint_output = checkpoints.hashval_query_r1_mtx.get(sample = s).output[0]
#        hashvals += expand("outputs/sgc_r1_mtx/megahit/{sample}_megahit/{hashval}.contigs.fa",
#                 sample = s,
#                 hashval = glob_wildcards(os.path.join(checkpoint_output, "{hashval}.cdbg_ids.reads.fa.gz")).hashval)
#    return hashvals

rule megahit_rone_mtx:
    output: 'outputs/sgc_r1_mtx/megahit/{sample}_megahit/{hashval}.contigs.fa'
    input: '{sample}_k31_r1_hashval_k51/{hashval}.cdbg_ids.reads.fa.gz'
    conda: 'env2.yml'
    params: output_folder = 'outputs/sgc_r1_mtx/megahit/'
    shell:'''
    # megahit does not allow force overwrite, so each assembly needs to occur
    # in it's own directory.
    megahit -r {input} --min-contig-len 142 \
        --out-dir {wildcards.sample}_r1_mtx_megahit \
        --out-prefix {wildcards.sample} 
    # move the final assembly to a folder containing all assemblies
    mv {wildcards.sample}_r1_mtx_megahit/{wildcards.sample}.contigs.fa {output}
    # remove the original megahit assembly folder, which is in the main directory.
    rm -rf {wildcards.sample}_r1_mtx_megahit
    ''' 

def aggregate_for_dvf(wildcards):
    hashvals = []
    for s in SAMPLES:
        checkpoint_output = checkpoints.hashval_query_r1_mtx.get(sample = s).output[0]
	hashvals += expand("outputs/sgc_r1_mtx/dvf/{sample}_dvf/{hashval}.contigs.fa_gt150bp_dvfpred.txt",
		 sample = s,
		 hashval = glob_wildcards(os.path.join(checkpoint_output, "{hashval}.cdbg_ids.reads.fa.gz")).hashval)
    return hashvals

rule dvf_rone_mtx:
    input: 'outputs/sgc_r1_mtx/megahit/{sample}_megahit/{hashval}.contigs.fa'
    #input: aggregate_for_megahit
    output: 'outputs/sgc_r1_mtx/dvf/{sample}_dvf/{hashval}.contigs.fa_gt150bp_dvfpred.txt'
    params: outdir = 'outputs/sgc_r1_mtx_dvf/{sample}_dvf'
    conda: 'dvf_env.yml'
    shell:'''
    python ~/github/DeepVirFinder/dvf.py -i {input} -o {params.outdir} -l 150
    '''
    
#############################################################################
## Metagenomes (MGX)
#############################################################################


subworkflow mgx_snakefile:
    snakefile: "snakefiles/mgx.snakefile"

rule untar_mgx:
    input: mgx_snakefile('inputs/mgx_tar/{sample}.tar')
    output: 
        'inputs/mgx/{sample}_R1.fastq.gz',
        'inputs/mgx/{sample}_R2.fastq.gz'
    message: '--- Untar data'
    shell:'''
    tar xf {input} --directory inputs/mgx
    '''

rule calculate_signatures_mgx:
    input:
        r1='inputs/mgx/{sample}_R1.fastq.gz',
        r2='inputs/mgx/{sample}_R2.fastq.gz'
    output: 'outputs/mgx_sigs/{sample}_mgx.scaled2k.sig'
    message: '--- Compute mgx sourmash sigs using quality trimmed data.'
    conda: 'env.yml'
#    benchmark: 'benchmarks/{sample}.compute_mgx.benchmark.txt'
    shell:'''
    sourmash compute -o {output} --merge {wildcards.sample}_mgx --scaled 2000 -k 21,31,51 --track-abundance {input.r1} {input.r2} 
    '''

rule gather_mgx:
    input: 
        sig = 'outputs/mgx_sigs/{sample}_mgx.scaled2k.sig',
        human = 'inputs/databases/GRCh38.p13_genomic.sig',
        db1 = 'inputs/databases/genbank-d2-k51.sbt.json',
        db2 = 'inputs/databases/pasolli-mags-k51.sbt.json',
        db3 = 'inputs/databases/almeida-mags-k51.sbt.json',
        db4 = 'inputs/databases/nayfach-k51.sbt.json'
    output:
        gather = 'outputs/mgx_gather/csvs/{sample}_mgx.gather',
        matches = 'outputs/mgx_gather/matches/{sample}_mgx.matches', 
        un = 'outputs/mgx_gather/unassigned/{sample}_mgx.un'
    message: '--- Classify MGX signatures with gather.'
    conda: 'env.yml'
#    benchmark: 'benchmarks/{sample}.gather.benchmark.txt'
    shell:'''
    sourmash gather -o {output.gather} --save-matches {output.matches} --output-unassigned {output.un} --scaled 2000 -k 51 {input.sig} {input.human} {input.db1} {input.db2} {input.db3} {input.db4}
    '''

rule calc_cosmo_kmers_mgx:
# This rule requires a script from github repo ctb/2017-sourmash-revindex.
    input: 
        un=expand('outputs/mgx_gather/unassigned/{sample}_mgx.un', sample = SAMPLES),
        script = 'scripts/hashes-to-numpy-2.py'
    output: 
        comp="outputs/cosmo/hmp_2k_t138_mgx",
        labels="outputs/cosmo/hmp_2k_t138_mgx.labels.txt"
    message: '--- Calculate cosmopolitan k-mers from unassigned hashes'
#    benchmark: 'benchmarks/calc_cosmo_kmers.benchmark.txt'
    conda:'env.yml'
    shell:'''
    {input.script} -o {output.comp} -k 51 --threshold=138 --scaled 2000 {input.un} 
    '''

