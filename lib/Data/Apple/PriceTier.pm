package Data::Apple::PriceTier;
use strict;
use warnings;
use Carp;
use 5.008001;

our $VERSION = '0.01';

our %COUNTRIES = (
    'U.S.'        => 0,
    'Canada'      => 1,
    'Mexico'      => 2,
    'Australia'   => 3,
    'New Zealand' => 4,
    'Japan'       => 5,
    'Europe'      => 6,
    'Switzerland' => 7,
    'Norway'      => 8,
    'U.K.'        => 9,
    'Denmark'     => 10,
    'Sweden'      => 11,
    'China'       => 12,
);

our %CURRENCIES = (
    'US$'  => 0,
    'CAD'  => 1,
    'MXP'  => 2,
    'AUD'  => 3,
    'NZD'  => 4,
    'Yen'  => 5,
    'Euro' => 6,
    'CHF'  => 7,
    'NOK'  => 8,
    'GBP'  => 9,
    'DKK'  => 10,
    'SEK'  => 11,
    'CNY'  => 12,
);

our $PRICE_MATRIX = [
    [    0.99,    0.99,   12.00,    0.99,    1.29,      85,    0.79,    1.00,    7.00,    0.69,    6.00,    7.00,       6],
    [    1.99,    1.99,      24,    1.99,    2.59,     170,    1.59,    2.00,   14.00,    1.49,   12.00,   15.00,      12],
    [    2.99,    2.99,      36,    2.99,    4.19,     250,    2.39,    3.00,   21.00,    1.99,   18.00,   22.00,      18],
    [    3.99,    3.99,      48,    4.49,    5.29,     350,    2.99,    4.00,   28.00,    2.49,   24.00,   28.00,      25],
    [    4.99,    4.99,      60,    5.49,    6.49,     450,    3.99,    5.00,   35.00,    2.99,   30.00,   38.00,      30],
    [    5.99,    5.99,      72,    6.49,    8.29,     500,    4.99,    6.00,   42.00,    3.99,   36.00,   45.00,      40],
    [    6.99,    6.99,      84,    7.49,    9.99,     600,    5.49,    7.00,   49.00,    4.99,   42.00,   49.00,      45],
    [    7.99,    7.99,      96,    8.49,   10.99,     700,    5.99,    8.00,   56.00,    5.49,   48.00,   55.00,      50],
    [    8.99,    8.99,     108,    9.49,   12.99,     800,    6.99,    9.00,   63.00,    5.99,   54.00,   65.00,      60],
    [    9.99,    9.99,     120,   10.49,   13.99,     850,    7.99,   10.00,   70.00,    6.99,   59.00,   75.00,      68],
    [   10.99,   10.99,     130,   11.49,   14.99,     900,    8.99,   11.00,   77.00,    7.49,   69.00,   85.00,      73],
    [   11.99,   11.99,     140,   12.99,   15.99,    1000,    9.99,   12.00,   84.00,    7.99,   75.00,   95.00,      78],
    [   12.99,   12.99,     160,   13.99,   16.99,    1100,   10.49,   13.00,   91.00,    8.99,   79.00,   99.00,      88],
    [   13.99,   13.99,     170,   14.99,   17.99,    1200,   10.99,   14.00,   98.00,    9.99,   85.00,  105.00,      93],
    [   14.99,   14.99,     180,   15.99,   18.99,    1300,   11.99,   15.00,  105.00,   10.49,   89.00,  109.00,      98],
    [   15.99,   15.99,     190,   16.99,   19.99,    1400,   12.99,   16.00,  112.00,   10.99,   99.00,  119.00,     108],
    [   16.99,   16.99,     200,   17.99,   20.99,    1500,   13.99,   17.00,  119.00,   11.99,  105.00,  129.00,     113],
    [   17.99,   17.99,     220,   18.99,   22.99,    1600,   14.49,   18.00,  126.00,   12.99,  109.00,  135.00,     118],
    [   18.99,   18.99,     230,   19.99,   23.99,    1650,   14.99,   19.00,  133.00,   13.49,  115.00,  139.00,     123],
    [   19.99,   19.99,     240,   20.99,   24.99,    1700,   15.99,   20.00,  140.00,   13.99,  119.00,  149.00,     128],
    [   20.99,   20.99,     250,   21.99,   25.99,    1800,   16.99,   21.00,  147.00,   14.99,  125.00,  159.00,     138],
    [   21.99,   21.99,     260,   22.99,   27.99,    1900,   17.99,   22.00,  154.00,   15.49,  129.00,  169.00,     148],
    [   22.99,   22.99,     270,   23.99,   28.99,    2000,   18.49,   23.00,  161.00,   15.99,  135.00,  175.00,     153],
    [   23.99,   23.99,     280,   24.99,   29.99,    2100,   18.99,   24.00,  168.00,   16.99,  139.00,  179.00,     158],
    [   24.99,   24.99,     300,   25.99,   30.99,    2200,   19.99,   25.00,  175.00,   17.49,  149.00,  189.00,     163],
    [   25.99,   25.99,     310,   26.99,   32.99,    2300,   20.99,   26.00,  182.00,   17.99,  155.00,  195.00,     168],
    [   26.99,   26.99,     320,   27.99,   34.99,    2400,   21.49,   27.00,  189.00,   18.99,  159.00,  199.00,     178],
    [   27.99,   27.99,     330,   29.99,   35.99,    2450,   21.99,   28.00,  196.00,   19.49,  165.00,  209.00,     188],
    [   28.99,   28.99,     340,   30.99,   36.99,    2500,   22.99,   28.50,  203.00,   19.99,  169.00,  219.00,     193],
    [   29.99,   29.99,     360,   31.99,   38.99,    2600,   23.99,   29.00,  209.00,   20.99,  179.00,  229.00,     198],
    [   30.99,   30.99,     370,   32.99,   39.99,    2700,   24.99,   30.00,  217.00,   21.99,  185.00,  235.00,     208],
    [   31.99,   31.99,     380,   33.99,   40.99,    2800,   25.49,   31.00,  224.00,   22.49,  189.00,  239.00,     218],
    [   32.99,   32.99,     390,   34.99,   41.99,    2900,   25.99,   32.00,  231.00,   22.99,  195.00,  245.00,     223],
    [   33.99,   33.99,     400,   35.99,   43.99,    2950,   26.99,   33.00,  238.00,   23.99,  199.00,  249.00,     228],
    [   34.99,   34.99,     420,   36.99,   44.99,    3000,   27.99,   34.00,  245.00,   24.49,  209.00,  265.00,     233],
    [   35.99,   35.99,     430,   37.99,   45.99,    3100,   28.99,   35.00,  252.00,   24.99,  215.00,  269.00,     238],
    [   36.99,   36.99,     440,   38.99,   46.99,    3200,   29.49,   36.00,  259.00,   25.99,  219.00,  275.00,     243],
    [   37.99,   37.99,     450,   39.99,   47.99,    3300,   29.99,   37.00,  266.00,   26.99,  225.00,  285.00,     248],
    [   38.99,   38.99,     470,   40.99,   48.99,    3400,   30.99,   38.00,  273.00,   27.49,  229.00,  289.00,     253],
    [   39.99,   39.99,     480,   41.99,   49.99,    3450,   31.99,   39.00,  280.00,   27.99,  239.00,  299.00,     258],
    [   40.99,   40.99,     490,   42.99,   50.99,    3500,   32.99,   40.00,  287.00,   28.99,  245.00,  309.00,     263],
    [   41.99,   41.99,     500,   43.99,   51.99,    3600,   33.49,   41.00,  294.00,   29.49,  249.00,  315.00,     268],
    [   42.99,   42.99,     520,   44.99,   53.99,    3700,   33.99,   42.00,  301.00,   29.99,  255.00,  319.00,     273],
    [   43.99,   43.99,     530,   45.99,   54.99,    3800,   34.99,   43.00,  308.00,   30.99,  259.00,  329.00,     278],
    [   44.99,   44.99,     540,   46.99,   55.99,    3900,   35.99,   44.00,  315.00,   31.99,  269.00,  339.00,     283],
    [   45.99,   45.99,     550,   47.99,   56.99,    3950,   36.99,   45.00,  322.00,   32.49,  275.00,  345.00,     288],
    [   46.99,   46.99,     560,   48.99,   58.99,    4000,   37.49,   46.00,  329.00,   32.99,  279.00,  349.00,     298],
    [   47.99,   47.99,     570,   49.99,   59.99,    4100,   37.99,   47.00,  336.00,   33.99,  285.00,  359.00,     308],
    [   48.99,   48.99,     580,   50.99,   60.99,    4200,   38.99,   47.50,  343.00,   34.49,  289.00,  369.00,     318],
    [   49.99,   49.99,     600,   51.99,   64.99,    4300,   39.99,   48.00,  349.00,   34.99,  299.00,  379.00,     328],
    [   54.99,   54.99,     650,   59.99,   74.99,    4800,   42.99,   55.00,  385.00,   37.99,  319.00,  399.00,     348],
    [   59.99,   59.99,     700,   64.99,   79.99,    5200,   44.99,   60.00,  420.00,   39.99,  339.00,  419.00,     388],
    [   64.99,   64.99,     800,   69.99,   84.99,    5700,   49.99,   65.00,  455.00,   44.99,  369.00,  469.00,     418],
    [   69.99,   69.99,     850,   74.99,   94.99,    6100,   54.99,   70.00,  490.00,   47.99,  399.00,  519.00,     448],
    [   74.99,   74.99,     900,   79.99,   99.99,    6500,   59.99,   75.00,  525.00,   49.99,  439.00,  569.00,     488],
    [   79.99,   79.99,     950,   84.99,  104.99,    6900,   62.99,   80.00,  560.00,   54.99,  469.00,  599.00,     518],
    [   84.99,   84.99,    1000,   89.99,  109.99,    7400,   64.99,   85.00,  595.00,   57.99,  499.00,  619.00,     548],
    [   89.99,   89.99,    1100,   94.99,  114.99,    7800,   69.99,   90.00,  630.00,   59.99,  529.00,  659.00,     588],
    [   94.99,   94.99,    1150,   99.99,  119.99,    8200,   74.99,   95.00,  665.00,   64.99,  559.00,  699.00,     618],
    [   99.99,   99.99,    1200,  109.99,  124.99,    8500,   79.99,  100.00,  700.00,   69.99,  599.00,  749.00,     648],
    [  109.99,  109.99,    1300,  119.99,  149.99,    9500,   84.99,  110.00,  770.00,   74.99,  629.00,  799.00,     698],
    [  119.99,  119.99,    1400,  129.99,  159.99,   10500,   89.99,  120.00,  840.00,   79.99,  669.00,  849.00,     798],
    [  124.99,  124.99,    1500,  134.99,  164.99,   11000,   92.99,  125.00,  870.00,   84.99,  689.00,  879.00,  818.00],
    [  129.99,  129.99,    1600,  139.99,  169.99,   11500,   94.99,  130.00,  910.00,   89.99,  699.00,  899.00,     848],
    [  139.99,  139.99,    1700,  149.99,  179.99,   12500,   99.99,  140.00,  980.00,   94.99,  749.00,  949.00,     898],
    [  149.99,  149.99,    1800,  159.99,  199.99,   13000,  109.99,  150.00, 1050.00,   99.99,  819.00,  999.00,     998],
    [  159.99,  159.99,    1900,  169.99,  209.99,   14000,  119.99,  160.00, 1120.00,  109.99,  899.00, 1099.00,    1048],
    [  169.99,  169.99,    2000,  179.99,  229.99,   15000,  124.99,  170.00, 1190.00,  119.99,  929.00, 1179.00,    1098],
    [  174.99,  174.99,    2100,  184.99,  234.99,   15500,  127.99,  175.00, 1220.00,  122.99,  949.00, 1199.00, 1148.00],
    [  179.99,  179.99,    2200,  189.99,  239.99,   16000,  129.99,  180.00, 1260.00,  124.99,  969.00, 1239.00,    1198],
    [  189.99,  189.99,    2300,  199.99,  249.99,   16500,  139.99,  190.00, 1330.00,  129.99, 1039.00, 1319.00,    1248],
    [  199.99,  199.99,    2400,  209.99,  259.99,   17000,  149.99,  200.00, 1400.00,  139.99, 1119.00, 1399.00,    1298],
    [  209.99,  209.99,    2500,  219.99,  269.99,   18000,  159.99,  210.00, 1470.00,  144.99, 1199.00, 1499.00,    1398],
    [  219.99,  219.99,    2700,  229.99,  279.99,   19000,  169.99,  220.00, 1540.00,  149.99, 1269.00, 1599.00,    1448],
    [  229.99,  229.99,    2800,  239.99,  289.99,   20000,  179.99,  230.00, 1610.00,  159.99, 1349.00, 1699.00,    1498],
    [  239.99,  239.99,    2900,  249.99,  299.99,   21000,  189.99,  240.00, 1680.00,  169.99, 1399.00, 1799.00,    1598],
    [  249.99,  249.99,    3000,  269.99,  319.99,   22000,  199.99,  250.00, 1750.00,  174.99, 1499.00, 1899.00,    1648],
    [  299.99,  299.99,    3600,  319.99,  399.99,   26000,  239.99,  300.00, 2100.00,  199.99, 1799.00, 2299.00,    1998],
    [  349.99,  349.99,    4200,  379.99,  449.99,   30000,  279.99,  350.00, 2450.00,  249.99, 1999.00, 2599.00,    2298],
    [  399.99,  399.99,    4800,  429.99,  499.99,   35000,  319.99,  400.00, 2800.00,  299.99, 2399.00, 2999.00,    2598],
    [  449.99,  449.99,    5400,  499.99,  549.99,   39000,  359.99,  450.00, 3150.00,  324.99, 2699.00, 3399.00,    2998],
    [  499.99,  499.99,    6000,  549.99,  649.99,   42500,  399.99,  500.00, 3500.00,  349.99, 2999.00, 3799.00,    3298],
    [  599.99,  599.99,    7200,  649.99,  749.99,   50000,  479.99,  600.00, 4200.00,  399.99, 3499.00, 4499.00,    3998],
    [  699.99,  699.99,    8400,  749.99,  849.99,   60000,  559.99,  700.00, 4900.00,  499.99, 3999.00, 5299.00,    4498],
    [  799.99,  799.99,    9600,  849.99,  949.99,   70000,  639.99,  800.00, 5600.00,  549.99, 4799.00, 5999.00,    4998],
    [  899.99,  899.99,   10800,  949.99, 1049.99,   80000,  719.99,  900.00, 6300.00,  599.99, 5499.00, 6799.00,    5898],
    [  999.99,  999.99,   12000, 1049.99, 1249.99,   85000,  799.99, 1000.00, 7000.00,  699.99, 5999.00, 7499.00,    6498],
];

our $PROCEED_MATRIX = [
    [    0.70,    0.70,    8.40,    0.63,    0.90,      60,    0.48,    0.65,    3.92,    0.42,    3.65,    4.26,    4.20],
    [    1.40,    1.40,   16.80,    1.27,    1.81,     119,    0.97,    1.30,    7.84,    0.91,    7.30,    9.13,    8.40],
    [    2.10,    2.10,   25.20,    1.90,    2.93,     175,    1.45,    1.94,   11.76,    1.21,   10.96,   13.39,   12.60],
    [    2.80,    2.80,   33.60,    2.86,    3.70,     245,    1.82,    2.59,   15.68,    1.52,   14.61,   17.04,   17.50],
    [    3.50,    3.50,   42.00,    3.49,    4.54,     315,    2.43,    3.24,   19.60,    1.82,   18.26,   23.13,   21.00],
    [    4.20,    4.20,   50.40,    4.13,    5.80,     350,    3.04,    3.89,   23.52,    2.43,   21.91,   27.39,   28.00],
    [    4.90,    4.90,   58.80,    4.77,    6.99,     420,    3.34,    4.54,   27.44,    3.04,   25.57,   29.83,   31.50],
    [    5.60,    5.60,   67.20,    5.40,    7.69,     490,    3.65,    5.19,   31.36,    3.34,   29.22,   33.48,   35.00],
    [    6.30,    6.30,   75.60,    6.04,    9.09,     560,    4.25,    5.83,   35.28,    3.65,   32.87,   39.57,   42.00],
    [    7.00,    7.00,   84.00,    6.68,    9.79,     595,    4.86,    6.48,   39.20,    4.25,   35.91,   45.65,   47.60],
    [    7.70,    7.70,   91.00,    7.31,   10.49,     630,    5.47,    7.13,   43.12,    4.56,   42.00,   51.74,   51.10],
    [    8.40,    8.40,   98.00,    8.27,   11.19,     700,    6.08,    7.78,   47.04,    4.86,   45.65,   57.83,   54.60],
    [    9.10,    9.10,  112.00,    8.90,   11.89,     770,    6.39,    8.43,   50.96,    5.47,   48.09,   60.26,   61.60],
    [    9.80,    9.80,  119.00,    9.54,   12.59,     840,    6.69,    9.07,   54.88,    6.08,   51.74,   63.91,   65.10],
    [   10.50,   10.50,  126.00,   10.18,   13.29,     910,    7.30,    9.72,   58.80,    6.39,   54.17,   66.35,   68.60],
    [   11.20,   11.20,  133.00,   10.81,   13.99,     980,    7.91,   10.37,   62.72,    6.69,   60.26,   72.43,   75.60],
    [   11.90,   11.90,  140.00,   11.45,   14.69,    1050,    8.52,   11.02,   66.64,    7.30,   63.91,   78.52,   79.10],
    [   12.60,   12.60,  154.00,   12.08,   16.09,    1120,    8.82,   11.67,   70.56,    7.91,   66.35,   82.17,   82.60],
    [   13.30,   13.30,  161.00,   12.72,   16.79,    1155,    9.12,   12.31,   74.48,    8.21,   70.00,   84.61,   86.10],
    [   14.00,   14.00,  168.00,   13.36,   17.49,    1190,    9.73,   12.96,   78.40,    8.52,   72.43,   90.70,   89.60],
    [   14.70,   14.70,  175.00,   13.99,   18.19,    1260,   10.34,   13.61,   82.32,    9.12,   76.09,   96.78,   96.60],
    [   15.40,   15.40,  182.00,   14.63,   19.59,    1330,   10.95,   14.26,   86.24,    9.43,   78.52,  102.87,  103.60],
    [   16.10,   16.10,  189.00,   15.27,   20.29,    1400,   11.25,   14.91,   90.16,    9.73,   82.17,  106.52,  107.10],
    [   16.80,   16.80,  196.00,   15.90,   20.99,    1470,   11.56,   15.56,   94.08,   10.34,   84.61,  108.96,  110.60],
    [   17.50,   17.50,  210.00,   16.54,   21.69,    1540,   12.17,   16.20,   98.00,   10.65,   90.70,  115.04,  114.10],
    [   18.20,   18.20,  217.00,   17.18,   23.09,    1610,   12.78,   16.85,  101.92,   10.95,   94.35,  118.70,  117.60],
    [   18.90,   18.90,  224.00,   17.81,   24.49,    1680,   13.08,   17.50,  105.84,   11.56,   96.78,  121.13,  124.60],
    [   19.60,   19.60,  231.00,   19.08,   25.19,    1715,   13.39,   18.15,  109.76,   11.86,  100.43,  127.22,  131.60],
    [   20.30,   20.30,  238.00,   19.72,   25.89,    1750,   13.99,   18.47,  113.68,   12.17,  102.87,  133.30,  138.60],
    [   21.00,   21.00,  252.00,   20.36,   27.29,    1820,   14.60,   18.80,  117.04,   12.78,  108.96,  139.39,  138.60],
    [   21.70,   21.70,  259.00,   20.99,   27.99,    1890,   15.21,   19.44,  121.52,   13.39,  112.61,  143.04,  145.60],
    [   22.40,   22.40,  266.00,   21.63,   28.69,    1960,   15.52,   20.09,  125.44,   13.69,  115.04,  145.48,  152.60],
    [   23.10,   23.10,  273.00,   22.27,   29.39,    2030,   15.82,   20.74,  129.36,   13.99,  118.70,  149.13,  156.10],
    [   23.80,   23.80,  280.00,   22.90,   30.79,    2065,   16.43,   21.39,  133.28,   14.60,  121.13,  151.57,  159.60],
    [   24.50,   24.50,  294.00,   23.54,   31.49,    2100,   17.04,   22.04,  137.20,   14.91,  127.22,  161.30,  163.10],
    [   25.20,   25.20,  301.00,   24.18,   32.19,    2170,   17.65,   22.69,  141.12,   15.21,  130.87,  163.74,  166.60],
    [   25.90,   25.90,  308.00,   24.81,   32.89,    2240,   17.95,   23.33,  145.04,   15.82,  133.30,  167.39,  170.10],
    [   26.60,   26.60,  315.00,   25.45,   33.59,    2310,   18.25,   23.98,  148.96,   16.43,  136.96,  173.48,  173.60],
    [   27.30,   27.30,  329.00,   26.08,   34.29,    2380,   18.86,   24.63,  152.88,   16.73,  139.39,  175.91,  177.10],
    [   28.00,   28.00,  336.00,   26.72,   34.99,    2415,   19.47,   25.28,  156.80,   17.04,  145.48,  182.00,  180.60],
    [   28.70,   28.70,  343.00,   27.36,   35.69,    2450,   20.08,   25.93,  160.72,   17.65,  149.13,  188.09,  184.10],
    [   29.40,   29.40,  350.00,   27.99,   36.39,    2520,   20.39,   26.57,  164.64,   17.95,  151.57,  191.74,  187.60],
    [   30.10,   30.10,  364.00,   28.63,   37.79,    2590,   20.69,   27.22,  168.56,   18.25,  155.22,  194.17,  191.10],
    [   30.80,   30.80,  371.00,   29.27,   38.49,    2660,   21.30,   27.87,  172.48,   18.86,  157.65,  200.26,  194.60],
    [   31.50,   31.50,  378.00,   29.90,   39.19,    2730,   21.91,   28.52,  176.40,   19.47,  163.74,  206.35,  198.10],
    [   32.20,   32.20,  385.00,   30.54,   39.89,    2765,   22.52,   29.17,  180.32,   19.78,  167.39,  210.00,  201.60],
    [   32.90,   32.90,  392.00,   31.18,   41.29,    2800,   22.82,   29.81,  184.24,   20.08,  169.83,  212.43,  208.60],
    [   33.60,   33.60,  399.00,   31.81,   41.99,    2870,   23.12,   30.46,  188.16,   20.69,  173.48,  218.52,  215.60],
    [   34.30,   34.30,  406.00,   32.45,   42.69,    2940,   23.73,   30.79,  192.08,   20.99,  175.91,  224.61,  222.60],
    [   35.00,   35.00,  420.00,   33.08,   45.49,    3010,   24.34,   31.11,  195.44,   21.30,  182.00,  230.70,  229.60],
    [   38.50,   38.50,  455.00,   38.18,   52.49,    3360,   26.17,   35.65,  215.60,   23.12,  194.17,  242.87,  243.60],
    [   42.00,   42.00,  490.00,   41.36,   55.99,    3640,   27.39,   38.89,  235.20,   24.34,  206.35,  255.04,  271.60],
    [   45.50,   45.50,  560.00,   44.54,   59.49,    3990,   30.43,   42.13,  254.80,   27.39,  224.61,  285.48,  292.60],
    [   49.00,   49.00,  595.00,   47.72,   66.49,    4270,   33.47,   45.37,  274.40,   29.21,  242.87,  315.91,  313.60],
    [   52.50,   52.50,  630.00,   50.90,   69.99,    4550,   36.52,   48.61,  294.00,   30.43,  267.22,  346.35,  341.60],
    [   56.00,   56.00,  665.00,   54.08,   73.49,    4830,   38.34,   51.85,  313.60,   33.47,  285.48,  364.61,  362.60],
    [   59.50,   59.50,  700.00,   57.27,   76.99,    5180,   39.56,   55.09,  333.20,   35.30,  303.74,  376.78,  383.60],
    [   63.00,   63.00,  770.00,   60.45,   80.49,    5460,   42.60,   58.33,  352.80,   36.52,  322.00,  401.13,  411.60],
    [   66.50,   66.50,  805.00,   63.63,   83.99,    5740,   45.65,   61.57,  372.40,   39.56,  340.26,  425.48,  432.60],
    [   70.00,   70.00,  840.00,   69.99,   87.49,    5950,   48.69,   64.81,  392.00,   42.60,  364.61,  455.91,  453.60],
    [   77.00,   77.00,  910.00,   76.36,  104.99,    6650,   51.73,   71.30,  431.20,   45.65,  382.87,  486.35,  488.60],
    [   84.00,   84.00,  980.00,   82.72,  111.99,    7350,   54.78,   77.78,  470.40,   48.69,  407.22,  516.78,  558.60],
    [   87.50,   87.50,    1050,   85.90,  115.49,    7700,   56.60,   81.02,  487.20,   51.73,  419.39,  535.04,  572.60],
    [   91.00,   91.00, 1120.00,   89.08,  118.99,    8050,   57.82,   84.26,  509.60,   54.78,  425.48,  547.22,  593.60],
    [   98.00,   98.00, 1190.00,   95.45,  125.99,    8750,   60.86,   90.74,  548.80,   57.82,  455.91,  577.65,  628.60],
    [  105.00,  105.00, 1260.00,  101.81,  139.99,    9100,   66.95,   97.22,  588.00,   60.86,  498.52,  608.09,  698.60],
    [  112.00,  112.00, 1330.00,  108.18,  146.99,    9800,   73.04,  103.70,  627.20,   66.95,  547.22,  668.96,  733.60],
    [  119.00,  119.00, 1400.00,  114.54,  160.99,   10500,   76.08,  110.19,  666.40,   73.04,  565.48,  717.65,  768.60],
    [  122.50,  122.50,    1470,  117.72,  164.49,   10850,   77.91,  113.43,  683.20,   74.86,  577.65,  729.83,  803.60],
    [  126.00,  126.00, 1540.00,  120.90,  167.99,   11200,   79.12,  116.67,  705.60,   76.08,  589.83,  754.17,  838.60],
    [  133.00,  133.00, 1610.00,  127.27,  174.99,   11550,   85.21,  123.15,  744.80,   79.12,  632.43,  802.87,  873.60],
    [  140.00,  140.00, 1680.00,  133.63,  181.99,   11900,   91.30,  129.63,  784.00,   85.21,  681.13,  851.57,  908.60],
    [  147.00,  147.00, 1750.00,  139.99,  188.99,   12600,   97.39,  136.11,  823.20,   88.25,  729.83,  912.43,  978.60],
    [  154.00,  154.00, 1890.00,  146.36,  195.99,   13300,  103.47,  142.59,  862.40,   91.30,  772.43,  973.30, 1013.60],
    [  161.00,  161.00, 1960.00,  152.72,  202.99,   14000,  109.56,  149.07,  901.60,   97.39,  821.13, 1034.17, 1048.60],
    [  168.00,  168.00, 2030.00,  159.08,  209.99,   14700,  115.65,  155.56,  940.80,  103.47,  851.57, 1095.04, 1118.60],
    [  175.00,  175.00, 2100.00,  171.81,  223.99,   15400,  121.73,  162.04,  980.00,  106.52,  912.43, 1155.91, 1153.60],
    [  210.00,  210.00, 2520.00,  203.63,  279.99,   18200,  146.08,  194.44, 1176.00,  121.73, 1095.04, 1399.39, 1398.60],
    [  245.00,  245.00, 2940.00,  241.81,  314.99,   21000,  170.43,  226.85, 1372.00,  152.17, 1216.78, 1582.00, 1608.60],
    [  280.00,  280.00, 3360.00,  273.63,  349.99,   24500,  194.78,  259.26, 1568.00,  182.60, 1460.26, 1825.48, 1818.60],
    [  315.00,  315.00, 3780.00,  318.18,  384.99,   27300,  219.12,  291.67, 1764.00,  197.82, 1642.87, 2068.96, 2098.60],
    [  350.00,  350.00, 4200.00,  349.99,  454.99,   29750,  243.47,  324.07, 1960.00,  213.04, 1825.48, 2312.43, 2308.60],
    [  420.00,  420.00, 5040.00,  413.63,  524.99,   35000,  292.17,  388.89, 2352.00,  243.47, 2129.83, 2738.52, 2798.60],
    [  490.00,  490.00, 5880.00,  477.27,  594.99,   42000,  340.86,  453.70, 2744.00,  304.34, 2434.17, 3225.48, 3148.60],
    [  560.00,  560.00, 6720.00,  540.90,  664.99,   49000,  389.56,  518.52, 3136.00,  334.78, 2921.13, 3651.57, 3498.60],
    [  630.00,  630.00, 7560.00,  604.54,  734.99,   56000,  438.25,  583.33, 3528.00,  365.21, 3347.22, 4138.52, 4128.60],
    [  700.00,  700.00, 8400.00,  668.18,  874.99,   59500,  486.95,  648.15, 3920.00,  426.08, 3651.57, 4564.61, 4548.60],
];

sub price_for {
    my ($class, %args) = @_;
    my $code = $class->_get_code(%args);

    my $tier = $args{tier}
        or croak 'tier parameter is required';

    $PRICE_MATRIX->[ $tier - 1 ][ $code ];
}

sub proceed_for {
    my ($class, %args) = @_;
    my $code = $class->_get_code(%args);

    my $tier = $args{tier}
        or croak 'tier parameter is required';

    $PROCEED_MATRIX->[ $tier - 1 ][ $code ];
}

sub supported_countries {
    return keys %COUNTRIES;
}

sub supported_currencies {
    return keys %CURRENCIES;
}

sub supported_countries_and_currencies {
    my %map;

    my $i = 0;
    my @currencies = keys %CURRENCIES;
    for my $country (keys %COUNTRIES) {
        $map{$country} = $currencies[$i++];
    }

    return %map;
}

sub new {
    my ($class, %args) = @_;

    my $code = $class->_get_code(%args);
    bless { code => $code }, $class;
}

sub price_for_tier {
    my ($self, $tier) = @_;
    $PRICE_MATRIX->[ $tier - 1 ][ $self->{code} ];
}

sub proceed_for_tier {
    my ($self, $tier) = @_;
    $PROCEED_MATRIX->[ $tier - 1 ][ $self->{code} ];
}

sub _get_code {
    my ($class_or_self, %args) = @_;

    my $code;
    if ($args{country}) {
        $code = $COUNTRIES{ $args{country} };
        croak "Unsupported country: $args{country}" unless defined $code;
    }
    elsif ($args{currency}) {
        $code = $CURRENCIES{ $args{currency} };
        croak "Unsupported currency: $args{currency}" unless defined $code;
    }
    else {
        croak 'required either country or currency parameter';
    }

    $code;
}

1;

__END__

=head1 NAME

Data::Apple::PriceTier - Utility for Apple (App|Mac) Store's price tier.

=head1 SYNOPSIS

    # class interface
    my $price = Data::Apple::PriceTier->price_for(
        currency => 'Euro',
        tier     => 1,
    ); # => 0.79
    
    my $proceed = Data::Apple::PriceTier->proceed_for(
        country => 'Japan',
        tier    => 1,
    ); # => 60
    
    # object interface
    my $us_tier = Data::Apple::PriceTier->new( country => 'U.S.' );
    my $price   = $us_tier->price_for_tier(1); # => 0.99

=head1 DESCRIPTION

Data::Apple::PriceTier is a simple utility module that helps you to convert Apple's price tier to real currencies.
It's useful to create server-side implementation of In-App purchases that supports multiple currencies.

=head1 CLASS METHODS

=head2 $price = Data::Apple::PriceTier->price_for(%args);

    $price = Data::Apple::PriceTier->price_for( currency => 'US$', tier => 1 );

Return customer price for C<%args>

Supported C<%args> is:

=over

=item * currency

=item * country

Specify target country or currency. Either country or currency is required.

=item * tier

Specify target price tier. Required.

=back

=head2 $proceed = Data::Apple::PriceTier->proceed_for(%args);

    $proceed = Data::Apple::PriceTier->proceed_for( currency => 'Yen', tier => 1 );

Return your proceed for C<%args>. Supported args is same as above C<price_for> method.

=head2 @prices = Data::Apple::PriceTier->prices(%country_or_currency);

    my @prices = Data::Apple::PriceTier->prices( country => 'Japan' );
    my @prices = Data::Apple::PriceTier->prices( currency => 'Yen' );

Return customer price list for given country or currency.

Note: this list start with tier 1. $prices[0] represent tier 1 price not Free price.

=head2 @proceeds = Data::Apple::PriceTier->proceeds(%country_or_currency);

    my @proceeds = Data::Apple::PriceTier->proceeds( country => 'Japan' );
    my @proceeds = Data::Apple::PriceTier->proceeds( currency => 'Yen' );

Return your proceed list for given country or currency.

=head2 $obj = Data::Apple::PriceTier->new(%country_or_currency);

Create Data::Apple::PriceTier object and return it. See C<INSTANCE METHODS> showed below for more detail.

=head2 @countries = Data::Apple::PriceTier->supported_countries;

List of countries that Apple (and this module) supports.

=head2 @currencies = Data::Apple::PriceTier->supported_currencies;

List of currencies that Apple (and this module) supports.

=head2 %countries_and_currencies = Data::Apple::PriceTier->supported_countries_and_currencies;

Return list of supported countries and currencies at once.

=head1 INSTANCE METHODS

=head2 $price = $obj->price_for_tier($tier);

Return customer price for C<$tier> with C<$obj>'s country.

=head2 $proceed = $obj->proceed_for_tier($tier);

Return your proceed for C<$tier> with C<$obj>'s country.

=head1 AUTHOR

Daisuke Murase <typester@cpan.org>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2012 KAYAC Inc. All rights reserved.

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.

=cut

