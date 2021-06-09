USE [stores7new]

CREATE TABLE [dbo].[call_type](
	[call_code] [char](1) NOT NULL,
	[code_descr] [varchar](30) NULL,
PRIMARY KEY CLUSTERED 
(
	[call_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE TABLE [dbo].[catalog](
	[catalog_num] [smallint] NOT NULL,
	[stock_num] [smallint] NOT NULL,
	[manu_code] [char](3) NOT NULL,
	[cat_descr] [text] NULL,
	[cat_picture] [varchar](255) NULL,
	[cat_advert] [varchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[catalog_num] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

CREATE TABLE [dbo].[cust_calls](
	[customer_num] [smallint] NOT NULL,
	[call_dtime] [datetime] NOT NULL,
	[user_id] [char](32) NULL,
	[call_code] [char](1) NULL,
	[call_descr] [varchar](240) NULL,
	[res_dtime] [datetime] NULL,
	[res_descr] [varchar](240) NULL,
PRIMARY KEY CLUSTERED 
(
	[customer_num] ASC,
	[call_dtime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE TABLE [dbo].[customer](
	[customer_num] [smallint] NOT NULL,
	[fname] [varchar](15) NULL,
	[lname] [varchar](15) NULL,
	[company] [varchar](20) NULL,
	[address1] [varchar](20) NULL,
	[address2] [varchar](20) NULL,
	[city] [varchar](15) NULL,
	[state] [char](2) NULL,
	[zipcode] [char](5) NULL,
	[phone] [varchar](18) NULL,
	[customer_num_referedBy] [smallint] NULL,
	[status] [char](1) NULL,
PRIMARY KEY CLUSTERED 
(
	[customer_num] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE TABLE [dbo].[items](
	[item_num] [smallint] NOT NULL,
	[order_num] [smallint] NOT NULL,
	[stock_num] [smallint] NOT NULL,
	[manu_code] [char](3) NOT NULL,
	[quantity] [smallint] NULL DEFAULT ((1)),
	[unit_price] [decimal](8, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[item_num] ASC,
	[order_num] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE TABLE [dbo].[manufact](
	[manu_code] [char](3) NOT NULL,
	[manu_name] [varchar](15) NULL,
	[lead_time] [smallint] NULL,
	[state] [char](2) NULL,
	[f_alta_audit] [datetime] NULL DEFAULT (getdate()),
	[d_usualta_audit] [varchar](20) NULL DEFAULT (user_name()),
PRIMARY KEY CLUSTERED 
(
	[manu_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE TABLE [dbo].[msgs](
	[lang] [varchar](32) NULL,
	[number] [smallint] NULL,
	[mesage] [varchar](255) NULL
) ON [PRIMARY]

CREATE TABLE [dbo].[orders](
	[order_num] [smallint] NOT NULL,
	[order_date] [datetime] NULL,
	[customer_num] [smallint] NOT NULL,
	[ship_instruct] [varchar](40) NULL,
	[backlog] [char](1) NULL,
	[po_num] [varchar](10) NULL,
	[ship_date] [datetime] NULL,
	[ship_weight] [decimal](8, 2) NULL,
	[ship_charge] [decimal](6, 2) NULL,
	[paid_date] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[order_num] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE TABLE [dbo].[product_types](
	[stock_num] [smallint] NOT NULL,
	[description] [varchar](15) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[stock_num] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE TABLE [dbo].[products](
	[stock_num] [smallint] NOT NULL,
	[manu_code] [char](3) NOT NULL,
	[unit_price] [decimal](6, 2) NULL,
	[unit_code] [smallint] NULL,
PRIMARY KEY CLUSTERED 
(
	[stock_num] ASC,
	[manu_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE TABLE [dbo].[state](
	[state] [char](2) NOT NULL,
	[sname] [varchar](15) NULL,
PRIMARY KEY CLUSTERED 
(
	[state] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE TABLE [dbo].[units](
	[unit_code] [smallint] IDENTITY(1,1) NOT NULL,
	[unit] [char](4) NULL,
	[unit_descr] [varchar](15) NULL,
PRIMARY KEY CLUSTERED 
(
	[unit_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

INSERT [dbo].[call_type] ([call_code], [code_descr]) VALUES (N'B', N'billing error')
INSERT [dbo].[call_type] ([call_code], [code_descr]) VALUES (N'D', N'damaged goods')
INSERT [dbo].[call_type] ([call_code], [code_descr]) VALUES (N'I', N'incorrect merchandise sent')
INSERT [dbo].[call_type] ([call_code], [code_descr]) VALUES (N'L', N'late shipment')
INSERT [dbo].[call_type] ([call_code], [code_descr]) VALUES (N'O', N'other')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10001, 1, N'HRO', N'Brown leather. Specify first baseman s or infield/outfield style.  Specify right- or 
left-handed.', N'', N'Your First Season s Baseball Glove')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10002, 1, N'HSK', N'Babe Ruth signature glove. Black leather. Infield/outfield style. Specify right- or 
left-handed.', N'', N'All Leather')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10003, 1, N'SMT', N'Catcher s mitt. Brown leather. Specify right- or left-handed.', N'', N'A Sturdy Catcher s 
Mitt With the Perfect Pocket')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10004, 2, N'HRO', N'Jackie Robinson signature ball. Highest professional quality', N'', N' used by National League.')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10005, 3, N'HSK', N'Pro-style wood. Available in sizes: 31', N'', N' 32 33')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10006, 3, N'SHM', N'Aluminum. Blue 
with black tape. 31" 20 oz or 22 oz; 32"', N'', N' 21 oz or 23 oz; 33"')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10007, 4, N'HSK', N'Norm Van 
Brocklin signature style.', N'', N'Quality Pigskin with Norm Van Brocklin 
Signature')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10008, 4, N'HRO', N'NFL Style 
pigskin.', N'', N'Highest Quality Football for High School and Collegiate 
Competitions')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10009, 5, N'NRG', N'Graphite frame. 
Synthetic strings.', N'', N'Wide Body Amplifies Your Natural Abilities by 
Providing More Power Through Aerodynamic Design')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10010, 5, N'SMT', N'Aluminum frame. Synthetic strings.', N'', N'Mid-Sized Racquet for the Improving Player')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10011, 5, N'ANZ', N'Wood frame', N'', N' cat-gut strings.')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10012, 6, N'SMT', N'Soft yellow color for easy visibility in sunlight or artificial light.', N'', N'High-Visibility Tennis')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10013, 6, N'ANZ', N'Pro-core. Available in neon yellow', N'', N' green and pink.')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10014, 7, N'HRO', N'Indoor. Classic NBA style. Brown leather.', N'', N'Long-Life Basketballs for Indoor 
Gymnasiums')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10015, 8, N'ANZ', N'Indoor. Finest leather. Professional quality.', N'', N'Professional Volleyballs for 
Indoor Competitions')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10016, 9, N'ANZ', N'Steel eyelets. Nylon cording. Double-stitched. Sanctioned by the National Athletic 
Congress', N'', N'Sanctioned Volleyball Netting for Indoor Professional and 
Collegiate Competition')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10017, 101, N'PRC', N'Reinforced', N'', N' hand-finished tubular. Polyurethane belted.  Effective against 
punctures. Mixed tread for super wear and road grip.')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10018, 101, N'SHM', N'Durable nylon 
casing with butyl tube for superior air retention.  Center-ribbed tread 
with herringbone side. Coated sidewalls resist abrasion.', N'', N'The 
Perfect Tire for Club Rides or Training')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10019, 102, N'SHM', N'Thrust bearing 
and coated pivot washer/spring sleeve for smooth action. Slotted levers 
with soft gum hoods. Two-tone paint treatment. Set includes calipers levers ', N'', N' and cables.')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10020, 102, N'PRC', N'Computer-aided 
design with low-profile pads. Cold-forged alloy calipers and beefy 
caliper bushing. Aero levers. Set includes calipers levers ', N'', N' and 
cables.')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10021, 103, N'PRC', N'Compact 
leading-action design enhances shifting. Deep cage for super-small granny 
gears. Extra strong construction to resist off-road abuse.', N'', N'Climb 
Any Mountain: ProCycle s Front Derailleur Adds Finesse to Your ATB')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10022, 104, N'PRC', N'Floating 
trapezoid geometry with extra thick parallelogram arms. 100-tooth capacity. 
Optimum alignment with any Freewheel.', N'', N'Computer-Aided Design 
Engineers 100-Tooth Capacity into ProCycle s Rear Derailleur')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10023, 105, N'PRC', N'Front wheels laced with 15 g spokes in a 3 cross pattern. Rear wheels laced with 14 g 
spikes in a 3-cross pattern.', N'', N'Durable Training Wheels That Hold 
True Under Toughest Conditions')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10024, 105, N'SHM', N'Polished alloy. Sealed-bearing', N'', N' quick-release hubs. Double-butted. Front wheels are laced 15 g/2-cross. Rear wheels are laced 15 g/3-cross.')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10025, 106, N'PRC', N'Hard anodized alloy with pearl finish. 6 mm hex bolt hardware. Available in lengths of 90-140 mm in 10 mm increments.', N'', N'ProCycle Stem with Pearl Finish')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10026, 107, N'PRC', N'Available in three styles: Men s racing; Men s touring; and Women s. Anatomical gel construction with lycra cover. Black or black/hot pink.', N'', N'The Ultimate in Riding Comfort')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10027, 108, N'SHM', N'Double or triple crankset with choice of chainrings. For double crankset', N'', N' chainrings from 38-54 teeth. For triple crankset chainrings from 24-48 teeth.')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10028, 109, N'PRC', N'Steel toe clips with nylon strap. Extra wide at buckle to reduce pressure.', N'', N'Classic Toeclip Improved to Prevent Soreness at Clip Buckle')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10029, 109, N'SHM', N'Ingenious new design combines button on sole of shoe with slot on a pedal plate to give riders new options in riding efficiency. Choose full or partial locking. Four plates mean both top and bottom of pedals are slotted -- no fishing around when you want to engage full power. Fast unlocking ensures safety when maneuverability is paramount.', N'', N'Ingenious Pedal/Clip Design Delivers Maximum Power and Fast Unlocking')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10030, 110, N'PRC', N'Super-lightweight. Meets both ANSI and Snell standards for impact protection. 7.5 oz. Quick-release shadow buckle.', N'', N'Feather-Light')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10031, 110, N'ANZ', N'No buckle so 
no plastic touches your chin. Meets both ANSI and Snell standards for 
impact protection. 7.5 oz. Lycra cover.', N'', N'Minimum Chin Contact')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10032, 110, N'SHM', N'Dense outer layer combines with softer inner layer to eliminate the mesh cover', N'', N' no snagging on brush. Meets both ANSI and Snell standards for impact 
protection. 8.0 oz.')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10033, 110, N'HRO', N'Newest ultralight helmet uses plastic shell. Largest ventilation channels of any helmet on the market. 8.5 oz.', N'', N'Lightweight Plastic with Vents Assures Cool Comfort Without Sacrificing Protection')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10034, 110, N'HSK', N'Aerodynamic 
(teardrop) helmet covered with anti-drag fabric. Credited with shaving 2 
seconds/mile from winner s time in Tour de France time trial. 7.5 oz.', N'', N'Teardrop Design Used by Yellow Jerseys; You Can Time the Difference')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10035, 111, N'SHM', N'Light-action 
shifting 10 speed. Designed for the city commuter with shock-absorbing 
front fork and drilled eyelets for carry-all racks or bicycle trailers. 
Internal wiring for generator lights. 33 lbs.', N'', N'Fully Equipped 
Bicycle Designed for the Serious Commuter Who Mixes Business with 
Pleasure')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10036, 112, N'SHM', N'Created for the beginner enthusiast. Ideal for club rides and light touring. 
Sophisticated triple-butted frame construction. Precise index shifting. 28 
lbs.', N'', N'We Selected the Ideal Combination of Touring Bike Equipment')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10037, 113, N'SHM', N'Ultra-lightweight. Racing frame geometry built for aerodynamic handlebars. Cantilever brakes. Index shifting. High-performance gearing. Quick-release hubs. Disk wheels. Bladed spokes.', N'', N'Designed for the Serious Competitor')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10038, 114, N'PRC', N'Padded leather palm and stretch mesh merged with terry back; available in tan black ', N'', N' and cream. Sizes S')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10039, 201, N'NKL', N'Designed for comfort and stability. Available in white & blue or white & brown. 
Specify size.', N'', N'Full-Comfort')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10040, 201, N'ANZ', N'Guaranteed waterproof. Full leather upper. Available in white', N'', N' bone brown')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10041, 201, N'KAR', N'Leather and leather mesh for maximum ventilation. Waterproof lining to keep feet dry. Available in white & gray or white & ivory.  Specify size.', N'', N'Karsten s Top Quality Shoe Combines Leather and Leather Mesh')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10042, 202, N'NKL', N'Complete starter set utilizes gold shafts. Balanced for power.', N'', N'Starter Set of Woods')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10043, 202, N'KAR', N'Full set of woods designed for precision control and power performance.', N'', N'High-Quality Woods Appropriate for High School Competitions or Serious 
Amateurs')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10044, 203, N'NKL', N'Set of eight irons includes 3 through 9 irons and pitching wedge. Originally priced at $489.00.', N'', N'Set of Irons Available from Factory at Tremendous Savings: Discontinued Line.')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10045, 204, N'KAR', N'Ideally balanced for optimum control. Nylon-covered shaft.', N'', N'High-Quality Beginning Set of Irons Appropriate for High School Competitions')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10046, 205, N'NKL', N'Fluorescent yellow.', N'', N'Long Drive Golf Balls: Fluorescent Yellow')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10047, 205, N'ANZ', N'White only.', N'', N'Long Drive Golf Balls: White')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10048, 205, N'HRO', N'Combination fluorescent yellow and standard white.', N'', N'HiFlier Golf Balls: Case Includes Fluorescent Yellow and Standard White')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10049, 301, N'NKL', N'Super shock-absorbing gel pads disperse vertical energy into a horizontal plane for extraordinary cushioned comfort. Great motion control. Mens only. Specify size.', N'', N'Maximum Protection For High-Mileage Runners')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10050, 301, N'HRO', N'Engineered for serious training with exceptional stability. Fabulous shock absorption. Great durability. Specify men s/women s', N'', N' size.')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10051, 301, N'SHM', N'For runners who log heavy miles and need a durable', N'', N' supportive stable 
platform. Mesh/synthetic upper gives excellent moisture dissipation. Stability 
system uses rear antipronation platform and forefoot control plate for 
extended protection during high-intensity training. Specify 
mens/womens')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10052, 301, N'PRC', N' Supportive', N'', N' stable racing flat. Plenty of forefoot cushioning with added motion 
control. Women s only. D widths available.  Specify size.')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10053, 301, N'KAR', N'Anatomical 
last holds your foot firmly in place. Feather-weight cushioning delivers 
the responsiveness of a racing flat. Specify men s/women s size.', N'', N'')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10054, 301, N'ANZ', N'Cantilever sole provides shock absorption and energy rebound. Positive traction shoe with ample toe box. Ideal for runners who need a wide shoe. Available 
in men s and women s. Specify size.', N'', N'Motion Control')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10055, 302, N'KAR', N'Re-usable ice pack with velcro strap. For general use. Velcro strap allows easy 
application to arms or legs.', N'', N'Finally')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10056, 303, N'PRC', N'Neon nylon. Perfect for running or aerobics. Indicate color: Fluorescent pink', N'', N' yellow green')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10057, 303, N'KAR', N'100% nylon blend for optimal wicking and comfort. We ve taken out the cotton to 
eliminate the risk of blisters and reduce the opportunity for infection. 
Specify men s or women s.', N'', N'100% Nylon Blend Socks - No Cotton!')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10058, 304, N'ANZ', N' Provides time date ', N'', N' dual display of lap/cumulative splits')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10059, 304, N'HRO', N'Split timer', N'', N' waterproof to 50 m. Indicate color: hot pink mint green')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10060, 305, N'HRO', N'Contains ace bandage', N'', N' anti-bacterial cream alcohol cleansing pads')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10061, 306, N'PRC', N'Converts a 
standard tandem bike into an adult/child bike. User-tested assembly 
instructions', N'', N'Enjoy Bicycling with Your Child on a Tandem; Make Your 
Family Outing Safer')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10062, 306, N'SHM', N'Converts a standard tandem bike into an adult/child bike.  Lightweight model.', N'', N'Consider a Touring Vacation For the Entire Family: A Lightweight')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10063, 307, N'PRC', N'Allows mom or 
dad to take the baby out', N'', N' too. Fits children up to 21 pounds. Navy 
blue with black trim.')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10064, 308, N'PRC', N'Allows mom or 
dad to take both children! Rated for children up to 18 pounds.', N'', N'As Your Family Grows')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10065, 309, N'HRO', N'Prevents 
swimmer s ear.', N'', N'Swimmers Can Prevent Ear Infection All Season Long')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10066, 309, N'SHM', N'Extra-gentle 
formula. Can be used every day for prevention or treatment of swimmer s 
ear.', N'', N'Swimmer s Ear Drops Specially Formulated for Children')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10067, 310, N'SHM', N'Blue 
heavy-duty foam board with Shimara or team logo.', N'', N'Exceptionally Durable')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10068, 310, N'ANZ', N'White. 
Standard size.', N'', N'High-Quality Kickboard')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10069, 311, N'SHM', N'Swim gloves. 
Webbing between fingers promotes strengthening of arms. Cannot be used 
in competition.', N'', N'Hot Training Tool - Webbed Swim Gloves Build Arm 
Strength and Endurance')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10070, 312, N'SHM', N'Hydrodynamic 
egg-shaped lens. Ground-in anti-fog elements; available in blue or 
smoke.', N'', N'Anti-Fog Swimmer s Goggles: Quantity Discount.')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10071, 312, N'HRO', N'Durable 
competition-style goggles. Available in blue', N'', N' grey or white.')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10072, 313, N'SHM', N'Silicone swim 
cap. One size. Available in white', N'', N' silver or navy. Team logo 
imprinting available')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10073, 313, N'ANZ', N'Silicone swim cap. Squared-off top. One size. White.', N'', N'Durable Squared-off 
Silicone Swim Cap')
INSERT [dbo].[catalog] ([catalog_num], [stock_num], [manu_code], [cat_descr], [cat_picture], [cat_advert]) VALUES (10074, 302, N'HRO', N'Re-usable ice 
pack. Store in the freezer for instant first-aid. Extra capacity to 
accommodate water and ice.', N'', N'Water Compartment Combines with Ice to 
Provide Optimal Orthopedic Treatment')
INSERT [dbo].[cust_calls] ([customer_num], [call_dtime], [user_id], [call_code], [call_descr], [res_dtime], [res_descr]) VALUES (106, CAST(N'2008-06-14 08:19:59.997' AS DateTime), N'maryj                           ', N'D', N'Order was received, but two of the cans of ANZ tennis balls within the case were empty', CAST(N'2015-06-13 08:24:59.997' AS DateTime), N'Authorized credit for two cans to customer, issued apology. Called ANZ buyer to report the QA problem.')
INSERT [dbo].[cust_calls] ([customer_num], [call_dtime], [user_id], [call_code], [call_descr], [res_dtime], [res_descr]) VALUES (110, CAST(N'2008-07-09 10:23:59.997' AS DateTime), N'richc                           ', N'L', N'Order placed one month ago (6/7) not received.', CAST(N'2015-07-08 10:30:00.000' AS DateTime), N'Checked with shipping (Ed Smith). Order sent yesterday- we were waiting for goods from ANZ. Next time will call with delay if necessary.')
INSERT [dbo].[cust_calls] ([customer_num], [call_dtime], [user_id], [call_code], [call_descr], [res_dtime], [res_descr]) VALUES (116, CAST(N'2007-11-30 13:34:00.000' AS DateTime), N'mannyn                          ', N'I', N'Received plain white swim caps (313 ANZ) instead of navy with team logo (313 SHM)', CAST(N'2015-11-28 16:47:00.000' AS DateTime), N'Shipping found correct case in warehouse and express mailed it in time for swim meet.')
INSERT [dbo].[cust_calls] ([customer_num], [call_dtime], [user_id], [call_code], [call_descr], [res_dtime], [res_descr]) VALUES (116, CAST(N'2007-12-23 11:23:59.997' AS DateTime), N'mannyn                          ', N'I', N'Second complaint from this customer! Received two cases right-handed outfielder gloves (1 HRO) instead of one case lefties.', CAST(N'2015-12-27 08:19:00.000' AS DateTime), N'Memo to shipping (Ava Brown) to send case of left-handed gloves, pick up wrong case')
INSERT [dbo].[cust_calls] ([customer_num], [call_dtime], [user_id], [call_code], [call_descr], [res_dtime], [res_descr]) VALUES (119, CAST(N'2008-07-03 15:00:00.000' AS DateTime), N'richc                           ', N'B', N'Bill does not reflect credit from previous order', CAST(N'2015-07-03 08:21:00.000' AS DateTime), N'Spoke with Jane Akant in Finance. She found the error and is sending new bill to customer')
INSERT [dbo].[cust_calls] ([customer_num], [call_dtime], [user_id], [call_code], [call_descr], [res_dtime], [res_descr]) VALUES (121, CAST(N'2008-07-12 14:05:00.000' AS DateTime), N'maryj                           ', N'O', N'Customer likes our merchandise. Requests that we stock more types of infant joggers. Will call back to place order.', CAST(N'2015-07-11 14:06:00.000' AS DateTime), N'Sent note to marketing group of interest in infant joggers')
INSERT [dbo].[cust_calls] ([customer_num], [call_dtime], [user_id], [call_code], [call_descr], [res_dtime], [res_descr]) VALUES (127, CAST(N'2008-08-02 14:30:00.000' AS DateTime), N'maryj                           ', N'I', N'Received Hero watches (item # 304) instead of ANZ watches', CAST(N'2014-12-04 00:00:00.000' AS DateTime), N'Sent memo to shipping to send ANZ item 304 to customer and pickup HRO watches. Should be done tomorrow, 8/1')
INSERT [dbo].[customer] ([customer_num], [fname], [lname], [company], [address1], [address2], [city], [state], [zipcode], [phone], [customer_num_referedBy], [status]) VALUES (101, N'Ludwig', N'Pauli', N'All Sports Supplies', N'213 Erstwild Court', N'', N'Sunnyvale', N'CA', N'94086', N'408-789-8075', NULL, NULL)
INSERT [dbo].[customer] ([customer_num], [fname], [lname], [company], [address1], [address2], [city], [state], [zipcode], [phone], [customer_num_referedBy], [status]) VALUES (102, N'Carole', N'Sadler', N'Sports Spot', N'785 Geary St', N'', N'San Francisco', N'CA', N'94117', N'415-822-1289', 101, NULL)
INSERT [dbo].[customer] ([customer_num], [fname], [lname], [company], [address1], [address2], [city], [state], [zipcode], [phone], [customer_num_referedBy], [status]) VALUES (103, N'Philip', N'Currie', N'Phil s Sports', N'654 Poplar', N'P. O. Box 3498', N'Palo Alto', N'CA', N'94303', N'415-328-4543', 101, NULL)
INSERT [dbo].[customer] ([customer_num], [fname], [lname], [company], [address1], [address2], [city], [state], [zipcode], [phone], [customer_num_referedBy], [status]) VALUES (104, N'Anthony', N'Higgins', N'Play Ball!', N'East Shopping Cntr.', N'422 Bay Road', N'Redwood City', N'CA', N'94026', N'415-368-1100', 103, NULL)
INSERT [dbo].[customer] ([customer_num], [fname], [lname], [company], [address1], [address2], [city], [state], [zipcode], [phone], [customer_num_referedBy], [status]) VALUES (105, N'Raymond', N'Vector', N'Los Altos Sports', N'1899 La Loma Drive', N'', N'Los Altos', N'CA', N'94022', N'415-776-3249', 103, NULL)
INSERT [dbo].[customer] ([customer_num], [fname], [lname], [company], [address1], [address2], [city], [state], [zipcode], [phone], [customer_num_referedBy], [status]) VALUES (106, N'George', N'Watson', N'Watson & Son', N'1143 Carver Place', N'', N'Mountain View', N'CA', N'94063', N'415-389-8789', 103, NULL)
INSERT [dbo].[customer] ([customer_num], [fname], [lname], [company], [address1], [address2], [city], [state], [zipcode], [phone], [customer_num_referedBy], [status]) VALUES (107, N'Charles', N'Ream', N'Athletic Supplies', N'41 Jordan Avenue', N'', N'Palo Alto', N'CA', N'94304', N'415-356-9876', NULL, NULL)
INSERT [dbo].[customer] ([customer_num], [fname], [lname], [company], [address1], [address2], [city], [state], [zipcode], [phone], [customer_num_referedBy], [status]) VALUES (108, N'Donald', N'Quinn', N'Quinn s Sports', N'587 Alvarado', N'', N'Redwood City', N'CA', N'94063', N'415-544-8729', 107, NULL)
INSERT [dbo].[customer] ([customer_num], [fname], [lname], [company], [address1], [address2], [city], [state], [zipcode], [phone], [customer_num_referedBy], [status]) VALUES (109, N'Jane', N'Miller', N'Sport Stuff', N'Mayfair Mart', N'7345 Ross Blvd.', N'Sunnyvale', N'CA', N'94086', N'408-723-8789', 107, NULL)
INSERT [dbo].[customer] ([customer_num], [fname], [lname], [company], [address1], [address2], [city], [state], [zipcode], [phone], [customer_num_referedBy], [status]) VALUES (110, N'Roy', N'Jaeger', N'AA Athletics', N'520 Topaz Way', N'', N'Redwood City', N'CA', N'94062', N'415-743-3611', NULL, NULL)
INSERT [dbo].[customer] ([customer_num], [fname], [lname], [company], [address1], [address2], [city], [state], [zipcode], [phone], [customer_num_referedBy], [status]) VALUES (111, N'Frances', N'Keyes', N'Sports Center', N'3199 Sterling Court', N'', N'Sunnyvale', N'CA', N'94085', N'408-277-7245', NULL, NULL)
INSERT [dbo].[customer] ([customer_num], [fname], [lname], [company], [address1], [address2], [city], [state], [zipcode], [phone], [customer_num_referedBy], [status]) VALUES (112, N'Margaret', N'Lawson', N'Runners & Others', N'234 Wyandotte Way', N'', N'Los Altos', N'CA', N'94022', N'415-887-7235', 111, NULL)
INSERT [dbo].[customer] ([customer_num], [fname], [lname], [company], [address1], [address2], [city], [state], [zipcode], [phone], [customer_num_referedBy], [status]) VALUES (113, N'Lana', N'Beatty', N'Sportstown', N'654 Oak Grove', N'', N'Menlo Park', N'CA', N'94025', N'415-356-9982', 111, NULL)
INSERT [dbo].[customer] ([customer_num], [fname], [lname], [company], [address1], [address2], [city], [state], [zipcode], [phone], [customer_num_referedBy], [status]) VALUES (114, N'Frank', N'Albertson', N'Sporting Place', N'947 Waverly Place', N'', N'Redwood City', N'CA', N'94062', N'415-886-6677', 111, NULL)
INSERT [dbo].[customer] ([customer_num], [fname], [lname], [company], [address1], [address2], [city], [state], [zipcode], [phone], [customer_num_referedBy], [status]) VALUES (115, N'Alfred', N'Grant', N'Gold Medal Sports', N'776 Gary Avenue', N'', N'Menlo Park', N'CA', N'94025', N'415-356-1123', NULL, NULL)
INSERT [dbo].[customer] ([customer_num], [fname], [lname], [company], [address1], [address2], [city], [state], [zipcode], [phone], [customer_num_referedBy], [status]) VALUES (116, N'Jean', N'Parmelee', N'Olympic City', N'1104 Spinosa Drive', N'', N'Mountain View', N'CA', N'94040', N'415-534-8822', 115, NULL)
INSERT [dbo].[customer] ([customer_num], [fname], [lname], [company], [address1], [address2], [city], [state], [zipcode], [phone], [customer_num_referedBy], [status]) VALUES (117, N'Arnold', N'Sipes', N'Kids Korner', N'850 Lytton Court', N'', N'Redwood City', N'CA', N'94063', N'415-245-4578', 115, NULL)
INSERT [dbo].[customer] ([customer_num], [fname], [lname], [company], [address1], [address2], [city], [state], [zipcode], [phone], [customer_num_referedBy], [status]) VALUES (118, N'Dick', N'Baxter', N'Blue Ribbon Sports', N'5427 College', N'', N'Oakland', N'CA', N'94609', N'415-655-0011', 115, NULL)
INSERT [dbo].[customer] ([customer_num], [fname], [lname], [company], [address1], [address2], [city], [state], [zipcode], [phone], [customer_num_referedBy], [status]) VALUES (119, N'Bob', N'Shorter', N'The Triathletes Club', N'2405 Kings Highway', N'', N'Cherry Hill', N'NJ', N'8002 ', N'609-663-6079', 115, NULL)
INSERT [dbo].[customer] ([customer_num], [fname], [lname], [company], [address1], [address2], [city], [state], [zipcode], [phone], [customer_num_referedBy], [status]) VALUES (120, N'Fred', N'Jewell', N'Century Pro Shop', N'6627 N. 17th Way', N'', N'Phoenix', N'AZ', N'85016', N'602-265-8754', NULL, NULL)
INSERT [dbo].[customer] ([customer_num], [fname], [lname], [company], [address1], [address2], [city], [state], [zipcode], [phone], [customer_num_referedBy], [status]) VALUES (121, N'Jason', N'Wallack', N'City Sports', N'Lake Biltmore Mall', N'350 W. 23rd Street', N'Wilmington', N'DE', N'19898', N'302-366-7511', 120, NULL)
INSERT [dbo].[customer] ([customer_num], [fname], [lname], [company], [address1], [address2], [city], [state], [zipcode], [phone], [customer_num_referedBy], [status]) VALUES (122, N'Cathy', N'O Brian', N'The Sporting Life', N'543 Nassau Street', N'', N'Princeton', N'NJ', N'8540 ', N'609-342-0054', 121, NULL)
INSERT [dbo].[customer] ([customer_num], [fname], [lname], [company], [address1], [address2], [city], [state], [zipcode], [phone], [customer_num_referedBy], [status]) VALUES (123, N'Marvin', N'Hanlon', N'Bay Sports', N'10100 Bay Meadows Ro', N'Suite 1020', N'Jacksonville', N'FL', N'32256', N'904-823-4239', 121, NULL)
INSERT [dbo].[customer] ([customer_num], [fname], [lname], [company], [address1], [address2], [city], [state], [zipcode], [phone], [customer_num_referedBy], [status]) VALUES (124, N'Chris', N'Putnum', N'Putnum s Putters', N'4715 S.E. Adams Blvd', N'Suite 909C', N'Bartlesville', N'OK', N'74006', N'918-355-2074', 120, NULL)
INSERT [dbo].[customer] ([customer_num], [fname], [lname], [company], [address1], [address2], [city], [state], [zipcode], [phone], [customer_num_referedBy], [status]) VALUES (125, N'James', N'Henry', N'Total Fitness Sports', N'1450 Commonwealth Av', N'', N'Brighton', N'MA', N'2135 ', N'617-232-4159', NULL, NULL)
INSERT [dbo].[customer] ([customer_num], [fname], [lname], [company], [address1], [address2], [city], [state], [zipcode], [phone], [customer_num_referedBy], [status]) VALUES (126, N'Eileen', N'Neelie', N'Neelie s Discount Sp', N'2539 South Utica Str', N'', N'Denver', N'CO', N'80219', N'303-936-7731', 125, NULL)
INSERT [dbo].[customer] ([customer_num], [fname], [lname], [company], [address1], [address2], [city], [state], [zipcode], [phone], [customer_num_referedBy], [status]) VALUES (127, N'Kim', N'Satifer', N'Big Blue Bike Shop', N'Blue Island Square', N'12222 Gregory Street', N'Blue Island', N'NY', N'60406', N'312-944-5691', 125, NULL)
INSERT [dbo].[customer] ([customer_num], [fname], [lname], [company], [address1], [address2], [city], [state], [zipcode], [phone], [customer_num_referedBy], [status]) VALUES (128, N'Frank', N'Lessor', N'Phoenix University', N'Athletic Department', N'1817 N. Thomas Road', N'Phoenix', N'AZ', N'85008', N'602-533-1817', 125, NULL)
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (1, 1001, 1, N'HRO', 5, CAST(250.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (1, 1002, 4, N'HSK', 1, CAST(960.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (1, 1003, 9, N'ANZ', 1, CAST(20.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (1, 1004, 1, N'HRO', 1, CAST(250.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (1, 1005, 5, N'NRG', 10, CAST(280.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (1, 1006, 5, N'SMT', 5, CAST(125.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (1, 1007, 1, N'HRO', 1, CAST(250.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (1, 1008, 8, N'ANZ', 1, CAST(840.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (1, 1009, 1, N'SMT', 1, CAST(450.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (1, 1010, 6, N'SMT', 1, CAST(36.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (1, 1011, 5, N'ANZ', 5, CAST(99.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (1, 1012, 8, N'ANZ', 1, CAST(840.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (1, 1013, 5, N'ANZ', 1, CAST(19.80 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (1, 1014, 4, N'HSK', 1, CAST(960.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (1, 1015, 1, N'SMT', 1, CAST(450.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (1, 1016, 101, N'SHM', 2, CAST(136.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (1, 1017, 201, N'NKL', 4, CAST(150.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (1, 1018, 307, N'PRC', 2, CAST(500.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (1, 1019, 111, N'SHM', 3, CAST(1499.97 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (1, 1020, 204, N'KAR', 2, CAST(90.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (1, 1021, 201, N'NKL', 2, CAST(75.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (1, 1022, 309, N'HRO', 1, CAST(40.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (1, 1023, 103, N'PRC', 2, CAST(40.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (2, 1002, 3, N'HSK', 1, CAST(240.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (2, 1003, 8, N'ANZ', 1, CAST(840.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (2, 1004, 2, N'HRO', 1, CAST(126.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (2, 1005, 5, N'ANZ', 10, CAST(198.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (2, 1006, 5, N'NRG', 5, CAST(140.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (2, 1007, 2, N'HRO', 1, CAST(126.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (2, 1008, 9, N'ANZ', 5, CAST(100.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (2, 1010, 6, N'ANZ', 1, CAST(48.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (2, 1012, 9, N'ANZ', 10, CAST(200.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (2, 1013, 6, N'SMT', 1, CAST(36.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (2, 1014, 4, N'HRO', 1, CAST(480.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (2, 1016, 109, N'PRC', 3, CAST(90.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (2, 1017, 202, N'KAR', 1, CAST(230.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (2, 1018, 302, N'KAR', 3, CAST(15.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (2, 1020, 301, N'KAR', 4, CAST(348.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (2, 1021, 201, N'ANZ', 3, CAST(225.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (2, 1022, 303, N'PRC', 2, CAST(96.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (2, 1023, 104, N'PRC', 2, CAST(116.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (3, 1003, 5, N'ANZ', 5, CAST(99.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (3, 1004, 3, N'HSK', 1, CAST(240.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (3, 1005, 6, N'SMT', 1, CAST(36.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (3, 1006, 5, N'ANZ', 5, CAST(99.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (3, 1007, 3, N'HSK', 1, CAST(240.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (3, 1013, 6, N'ANZ', 1, CAST(48.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (3, 1016, 110, N'HSK', 1, CAST(308.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (3, 1017, 301, N'SHM', 2, CAST(204.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (3, 1018, 110, N'PRC', 1, CAST(236.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (3, 1021, 202, N'KAR', 3, CAST(690.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (3, 1022, 6, N'ANZ', 2, CAST(96.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (3, 1023, 105, N'SHM', 1, CAST(80.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (4, 1004, 1, N'HSK', 1, CAST(800.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (4, 1005, 6, N'ANZ', 1, CAST(48.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (4, 1006, 6, N'SMT', 1, CAST(36.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (4, 1007, 4, N'HRO', 1, CAST(480.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (4, 1013, 9, N'ANZ', 2, CAST(40.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (4, 1016, 114, N'PRC', 1, CAST(120.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (4, 1018, 5, N'SMT', 4, CAST(100.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (4, 1021, 205, N'ANZ', 2, CAST(624.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (4, 1023, 110, N'SHM', 1, CAST(228.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (5, 1006, 6, N'ANZ', 1, CAST(48.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (5, 1007, 7, N'HRO', 1, CAST(600.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (5, 1018, 304, N'HRO', 1, CAST(280.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (5, 1023, 304, N'ANZ', 1, CAST(170.00 AS Decimal(8, 2)))
INSERT [dbo].[items] ([item_num], [order_num], [stock_num], [manu_code], [quantity], [unit_price]) VALUES (6, 1023, 306, N'SHM', 1, CAST(190.00 AS Decimal(8, 2)))
INSERT [dbo].[manufact] ([manu_code], [manu_name], [lead_time], [state], [f_alta_audit], [d_usualta_audit]) VALUES (N'ANZ', N'Anza', 5, N'CA', NULL, NULL)
INSERT [dbo].[manufact] ([manu_code], [manu_name], [lead_time], [state], [f_alta_audit], [d_usualta_audit]) VALUES (N'FUA', N'Manu Orden 2000', 1, NULL, CAST(N'2021-06-09 01:18:35.440' AS DateTime), N'dbo')
INSERT [dbo].[manufact] ([manu_code], [manu_name], [lead_time], [state], [f_alta_audit], [d_usualta_audit]) VALUES (N'HRO', N'Hero', 4, N'CA', NULL, NULL)
INSERT [dbo].[manufact] ([manu_code], [manu_name], [lead_time], [state], [f_alta_audit], [d_usualta_audit]) VALUES (N'HSK', N'Husky', 5, N'CA', NULL, NULL)
INSERT [dbo].[manufact] ([manu_code], [manu_name], [lead_time], [state], [f_alta_audit], [d_usualta_audit]) VALUES (N'KAR', N'Karsten', 21, N'CA', NULL, NULL)
INSERT [dbo].[manufact] ([manu_code], [manu_name], [lead_time], [state], [f_alta_audit], [d_usualta_audit]) VALUES (N'NKL', N'Nikolus', 8, N'AZ', NULL, NULL)
INSERT [dbo].[manufact] ([manu_code], [manu_name], [lead_time], [state], [f_alta_audit], [d_usualta_audit]) VALUES (N'NRG', N'Norge', 7, N'AZ', NULL, NULL)
INSERT [dbo].[manufact] ([manu_code], [manu_name], [lead_time], [state], [f_alta_audit], [d_usualta_audit]) VALUES (N'PRC', N'ProCycle', 9, N'AZ', NULL, NULL)
INSERT [dbo].[manufact] ([manu_code], [manu_name], [lead_time], [state], [f_alta_audit], [d_usualta_audit]) VALUES (N'SHM', N'Shimara', 30, N'CO', NULL, NULL)
INSERT [dbo].[manufact] ([manu_code], [manu_name], [lead_time], [state], [f_alta_audit], [d_usualta_audit]) VALUES (N'SMT', N'Smith', 3, N'CO', NULL, NULL)
INSERT [dbo].[orders] ([order_num], [order_date], [customer_num], [ship_instruct], [backlog], [po_num], [ship_date], [ship_weight], [ship_charge], [paid_date]) VALUES (1001, CAST(N'2015-05-16 00:00:00.000' AS DateTime), 104, N'express', N'n', N'B77836', CAST(N'2015-05-28 00:00:00.000' AS DateTime), CAST(20.40 AS Decimal(8, 2)), CAST(10.00 AS Decimal(6, 2)), CAST(N'2015-07-18 00:00:00.000' AS DateTime))
INSERT [dbo].[orders] ([order_num], [order_date], [customer_num], [ship_instruct], [backlog], [po_num], [ship_date], [ship_weight], [ship_charge], [paid_date]) VALUES (1002, CAST(N'2015-05-17 00:00:00.000' AS DateTime), 101, N'PO on box; deliver to back door only', N'n', N'9270', CAST(N'2015-05-22 00:00:00.000' AS DateTime), CAST(50.60 AS Decimal(8, 2)), CAST(15.30 AS Decimal(6, 2)), CAST(N'2015-05-30 00:00:00.000' AS DateTime))
INSERT [dbo].[orders] ([order_num], [order_date], [customer_num], [ship_instruct], [backlog], [po_num], [ship_date], [ship_weight], [ship_charge], [paid_date]) VALUES (1003, CAST(N'2015-05-18 00:00:00.000' AS DateTime), 104, N'express', N'n', N'B77890', CAST(N'2015-05-19 00:00:00.000' AS DateTime), CAST(35.60 AS Decimal(8, 2)), CAST(10.80 AS Decimal(6, 2)), CAST(N'2015-06-10 00:00:00.000' AS DateTime))
INSERT [dbo].[orders] ([order_num], [order_date], [customer_num], [ship_instruct], [backlog], [po_num], [ship_date], [ship_weight], [ship_charge], [paid_date]) VALUES (1004, CAST(N'2015-05-18 00:00:00.000' AS DateTime), 106, N'ring bell twice', N'y', N'8006', CAST(N'2015-05-26 00:00:00.000' AS DateTime), CAST(95.80 AS Decimal(8, 2)), CAST(19.20 AS Decimal(6, 2)), NULL)
INSERT [dbo].[orders] ([order_num], [order_date], [customer_num], [ship_instruct], [backlog], [po_num], [ship_date], [ship_weight], [ship_charge], [paid_date]) VALUES (1005, CAST(N'2015-05-20 00:00:00.000' AS DateTime), 116, N'call before delivery', N'n', N'2865', CAST(N'2015-06-05 00:00:00.000' AS DateTime), CAST(80.80 AS Decimal(8, 2)), CAST(16.20 AS Decimal(6, 2)), CAST(N'2015-06-17 00:00:00.000' AS DateTime))
INSERT [dbo].[orders] ([order_num], [order_date], [customer_num], [ship_instruct], [backlog], [po_num], [ship_date], [ship_weight], [ship_charge], [paid_date]) VALUES (1006, CAST(N'2015-05-26 00:00:00.000' AS DateTime), 112, N'after 10 am', N'y', N'Q13557', NULL, CAST(70.80 AS Decimal(8, 2)), CAST(14.20 AS Decimal(6, 2)), NULL)
INSERT [dbo].[orders] ([order_num], [order_date], [customer_num], [ship_instruct], [backlog], [po_num], [ship_date], [ship_weight], [ship_charge], [paid_date]) VALUES (1007, CAST(N'2015-05-27 00:00:00.000' AS DateTime), 117, N'', N'n', N'278693', CAST(N'2015-06-01 00:00:00.000' AS DateTime), CAST(125.90 AS Decimal(8, 2)), CAST(25.20 AS Decimal(6, 2)), NULL)
INSERT [dbo].[orders] ([order_num], [order_date], [customer_num], [ship_instruct], [backlog], [po_num], [ship_date], [ship_weight], [ship_charge], [paid_date]) VALUES (1008, CAST(N'2015-06-03 00:00:00.000' AS DateTime), 110, N'closed Monday', N'y', N'LZ230', CAST(N'2015-07-02 00:00:00.000' AS DateTime), CAST(45.60 AS Decimal(8, 2)), CAST(13.80 AS Decimal(6, 2)), CAST(N'2015-07-17 00:00:00.000' AS DateTime))
INSERT [dbo].[orders] ([order_num], [order_date], [customer_num], [ship_instruct], [backlog], [po_num], [ship_date], [ship_weight], [ship_charge], [paid_date]) VALUES (1009, CAST(N'2015-06-10 00:00:00.000' AS DateTime), 111, N'next door to grocery', N'n', N'4745', CAST(N'2015-06-17 00:00:00.000' AS DateTime), CAST(20.40 AS Decimal(8, 2)), CAST(10.00 AS Decimal(6, 2)), CAST(N'2015-08-17 00:00:00.000' AS DateTime))
INSERT [dbo].[orders] ([order_num], [order_date], [customer_num], [ship_instruct], [backlog], [po_num], [ship_date], [ship_weight], [ship_charge], [paid_date]) VALUES (1010, CAST(N'2015-06-13 00:00:00.000' AS DateTime), 115, N'deliver 776 King St. if no answer', N'n', N'429Q', CAST(N'2015-06-25 00:00:00.000' AS DateTime), CAST(40.60 AS Decimal(8, 2)), CAST(12.30 AS Decimal(6, 2)), CAST(N'2015-08-18 00:00:00.000' AS DateTime))
INSERT [dbo].[orders] ([order_num], [order_date], [customer_num], [ship_instruct], [backlog], [po_num], [ship_date], [ship_weight], [ship_charge], [paid_date]) VALUES (1011, CAST(N'2015-06-14 00:00:00.000' AS DateTime), 104, N'express', N'n', N'B77897', CAST(N'2015-06-29 00:00:00.000' AS DateTime), CAST(10.40 AS Decimal(8, 2)), CAST(5.00 AS Decimal(6, 2)), CAST(N'2015-08-25 00:00:00.000' AS DateTime))
INSERT [dbo].[orders] ([order_num], [order_date], [customer_num], [ship_instruct], [backlog], [po_num], [ship_date], [ship_weight], [ship_charge], [paid_date]) VALUES (1012, CAST(N'2015-06-14 00:00:00.000' AS DateTime), 117, N'', N'n', N'278701', CAST(N'2015-06-25 00:00:00.000' AS DateTime), CAST(70.80 AS Decimal(8, 2)), CAST(14.20 AS Decimal(6, 2)), NULL)
INSERT [dbo].[orders] ([order_num], [order_date], [customer_num], [ship_instruct], [backlog], [po_num], [ship_date], [ship_weight], [ship_charge], [paid_date]) VALUES (1013, CAST(N'2015-06-18 00:00:00.000' AS DateTime), 104, N'express', N'n', N'B77930', CAST(N'2015-07-06 00:00:00.000' AS DateTime), CAST(60.80 AS Decimal(8, 2)), CAST(12.20 AS Decimal(6, 2)), CAST(N'2015-07-27 00:00:00.000' AS DateTime))
INSERT [dbo].[orders] ([order_num], [order_date], [customer_num], [ship_instruct], [backlog], [po_num], [ship_date], [ship_weight], [ship_charge], [paid_date]) VALUES (1014, CAST(N'2015-06-21 00:00:00.000' AS DateTime), 106, N'ring bell kick door loudly', N'n', N' ', NULL, CAST(40.60 AS Decimal(8, 2)), CAST(12.30 AS Decimal(6, 2)), NULL)
INSERT [dbo].[orders] ([order_num], [order_date], [customer_num], [ship_instruct], [backlog], [po_num], [ship_date], [ship_weight], [ship_charge], [paid_date]) VALUES (1015, CAST(N'2015-06-23 00:00:00.000' AS DateTime), 110, N'closed Mondays', N'n', N'MA003', CAST(N'2015-07-12 00:00:00.000' AS DateTime), CAST(20.60 AS Decimal(8, 2)), CAST(6.30 AS Decimal(6, 2)), CAST(N'2015-08-27 00:00:00.000' AS DateTime))
INSERT [dbo].[orders] ([order_num], [order_date], [customer_num], [ship_instruct], [backlog], [po_num], [ship_date], [ship_weight], [ship_charge], [paid_date]) VALUES (1016, CAST(N'2015-06-25 00:00:00.000' AS DateTime), 119, N'delivery entrance off Camp St.', N'n', N'PC6782', CAST(N'2015-07-08 00:00:00.000' AS DateTime), CAST(35.00 AS Decimal(8, 2)), CAST(11.80 AS Decimal(6, 2)), NULL)
INSERT [dbo].[orders] ([order_num], [order_date], [customer_num], [ship_instruct], [backlog], [po_num], [ship_date], [ship_weight], [ship_charge], [paid_date]) VALUES (1017, CAST(N'2015-07-05 00:00:00.000' AS DateTime), 120, N'North side of clubhouse', N'n', N'DM354331', CAST(N'2015-07-09 00:00:00.000' AS DateTime), CAST(60.00 AS Decimal(8, 2)), CAST(18.00 AS Decimal(6, 2)), NULL)
INSERT [dbo].[orders] ([order_num], [order_date], [customer_num], [ship_instruct], [backlog], [po_num], [ship_date], [ship_weight], [ship_charge], [paid_date]) VALUES (1018, CAST(N'2015-07-06 00:00:00.000' AS DateTime), 121, N'SW corner of Biltmore Mall', N'n', N'S22942', CAST(N'2015-07-09 00:00:00.000' AS DateTime), CAST(70.50 AS Decimal(8, 2)), CAST(20.00 AS Decimal(6, 2)), CAST(N'2015-08-02 00:00:00.000' AS DateTime))
INSERT [dbo].[orders] ([order_num], [order_date], [customer_num], [ship_instruct], [backlog], [po_num], [ship_date], [ship_weight], [ship_charge], [paid_date]) VALUES (1019, CAST(N'2015-07-07 00:00:00.000' AS DateTime), 122, N'closed til noon Mondays', N'n', N'Z55709', CAST(N'2015-07-12 00:00:00.000' AS DateTime), CAST(90.00 AS Decimal(8, 2)), CAST(23.00 AS Decimal(6, 2)), CAST(N'2015-08-02 00:00:00.000' AS DateTime))
INSERT [dbo].[orders] ([order_num], [order_date], [customer_num], [ship_instruct], [backlog], [po_num], [ship_date], [ship_weight], [ship_charge], [paid_date]) VALUES (1020, CAST(N'2015-07-07 00:00:00.000' AS DateTime), 123, N'express', N'n', N'W2286', CAST(N'2015-07-12 00:00:00.000' AS DateTime), CAST(14.00 AS Decimal(8, 2)), CAST(8.50 AS Decimal(6, 2)), CAST(N'2015-09-16 00:00:00.000' AS DateTime))
INSERT [dbo].[orders] ([order_num], [order_date], [customer_num], [ship_instruct], [backlog], [po_num], [ship_date], [ship_weight], [ship_charge], [paid_date]) VALUES (1021, CAST(N'2015-07-19 00:00:00.000' AS DateTime), 124, N'ask for Elaine', N'n', N'C3288', CAST(N'2015-07-21 00:00:00.000' AS DateTime), CAST(40.00 AS Decimal(8, 2)), CAST(12.00 AS Decimal(6, 2)), CAST(N'2015-08-18 00:00:00.000' AS DateTime))
INSERT [dbo].[orders] ([order_num], [order_date], [customer_num], [ship_instruct], [backlog], [po_num], [ship_date], [ship_weight], [ship_charge], [paid_date]) VALUES (1022, CAST(N'2015-07-20 00:00:00.000' AS DateTime), 126, N'express', N'n', N'W9925', CAST(N'2015-07-26 00:00:00.000' AS DateTime), CAST(15.00 AS Decimal(8, 2)), CAST(13.00 AS Decimal(6, 2)), CAST(N'2015-08-29 00:00:00.000' AS DateTime))
INSERT [dbo].[orders] ([order_num], [order_date], [customer_num], [ship_instruct], [backlog], [po_num], [ship_date], [ship_weight], [ship_charge], [paid_date]) VALUES (1023, CAST(N'2015-07-20 00:00:00.000' AS DateTime), 127, N'no deliveries after 3 p.m.', N'n', N'KF2961', CAST(N'2015-07-26 00:00:00.000' AS DateTime), CAST(60.00 AS Decimal(8, 2)), CAST(18.00 AS Decimal(6, 2)), CAST(N'2015-08-18 00:00:00.000' AS DateTime))
INSERT [dbo].[product_types] ([stock_num], [description]) VALUES (1, N'baseball gloves')
INSERT [dbo].[product_types] ([stock_num], [description]) VALUES (2, N'baseball')
INSERT [dbo].[product_types] ([stock_num], [description]) VALUES (3, N'baseball bat')
INSERT [dbo].[product_types] ([stock_num], [description]) VALUES (4, N'football')
INSERT [dbo].[product_types] ([stock_num], [description]) VALUES (5, N'tennis racquet')
INSERT [dbo].[product_types] ([stock_num], [description]) VALUES (6, N'tennis ball')
INSERT [dbo].[product_types] ([stock_num], [description]) VALUES (7, N'basketball')
INSERT [dbo].[product_types] ([stock_num], [description]) VALUES (8, N'volleyball')
INSERT [dbo].[product_types] ([stock_num], [description]) VALUES (9, N'volleyball net')
INSERT [dbo].[product_types] ([stock_num], [description]) VALUES (101, N'bicycle tires')
INSERT [dbo].[product_types] ([stock_num], [description]) VALUES (102, N'bicycle brakes')
INSERT [dbo].[product_types] ([stock_num], [description]) VALUES (103, N'frnt derailleur')
INSERT [dbo].[product_types] ([stock_num], [description]) VALUES (104, N'rear derailleur')
INSERT [dbo].[product_types] ([stock_num], [description]) VALUES (105, N'bicycle wheels')
INSERT [dbo].[product_types] ([stock_num], [description]) VALUES (106, N'bicycle stem')
INSERT [dbo].[product_types] ([stock_num], [description]) VALUES (107, N'bicycle saddle')
INSERT [dbo].[product_types] ([stock_num], [description]) VALUES (108, N'crankset')
INSERT [dbo].[product_types] ([stock_num], [description]) VALUES (109, N'pedal binding')
INSERT [dbo].[product_types] ([stock_num], [description]) VALUES (110, N'helmet')
INSERT [dbo].[product_types] ([stock_num], [description]) VALUES (111, N'10-spd assmbld')
INSERT [dbo].[product_types] ([stock_num], [description]) VALUES (112, N'12-spd assmbld')
INSERT [dbo].[product_types] ([stock_num], [description]) VALUES (113, N'18-spd assmbld')
INSERT [dbo].[product_types] ([stock_num], [description]) VALUES (114, N'bicycle gloves')
INSERT [dbo].[product_types] ([stock_num], [description]) VALUES (201, N'golf shoes')
INSERT [dbo].[product_types] ([stock_num], [description]) VALUES (202, N'metal woods')
INSERT [dbo].[product_types] ([stock_num], [description]) VALUES (203, N'irons/wedge')
INSERT [dbo].[product_types] ([stock_num], [description]) VALUES (204, N'putter')
INSERT [dbo].[product_types] ([stock_num], [description]) VALUES (205, N'3 golf balls')
INSERT [dbo].[product_types] ([stock_num], [description]) VALUES (301, N'running shoes')
INSERT [dbo].[product_types] ([stock_num], [description]) VALUES (302, N'ice pack')
INSERT [dbo].[product_types] ([stock_num], [description]) VALUES (303, N'socks')
INSERT [dbo].[product_types] ([stock_num], [description]) VALUES (304, N'watch')
INSERT [dbo].[product_types] ([stock_num], [description]) VALUES (305, N'first-aid kit')
INSERT [dbo].[product_types] ([stock_num], [description]) VALUES (306, N'tandem adapter')
INSERT [dbo].[product_types] ([stock_num], [description]) VALUES (307, N'infant jogger')
INSERT [dbo].[product_types] ([stock_num], [description]) VALUES (308, N'twin jogger')
INSERT [dbo].[product_types] ([stock_num], [description]) VALUES (309, N'ear drops')
INSERT [dbo].[product_types] ([stock_num], [description]) VALUES (310, N'kick board')
INSERT [dbo].[product_types] ([stock_num], [description]) VALUES (311, N'water gloves')
INSERT [dbo].[product_types] ([stock_num], [description]) VALUES (312, N'racer goggles')
INSERT [dbo].[product_types] ([stock_num], [description]) VALUES (313, N'swim cap')
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (1, N'HRO', CAST(400.00 AS Decimal(6, 2)), 2)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (1, N'HSK', CAST(800.00 AS Decimal(6, 2)), 6)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (1, N'SMT', CAST(450.00 AS Decimal(6, 2)), 6)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (2, N'HRO', CAST(126.00 AS Decimal(6, 2)), 13)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (3, N'HSK', CAST(240.00 AS Decimal(6, 2)), 9)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (3, N'SHM', CAST(280.00 AS Decimal(6, 2)), 9)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (4, N'HRO', CAST(480.00 AS Decimal(6, 2)), 13)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (4, N'HSK', CAST(960.00 AS Decimal(6, 2)), 13)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (5, N'ANZ', CAST(19.80 AS Decimal(6, 2)), 19)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (5, N'NRG', CAST(28.00 AS Decimal(6, 2)), 19)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (5, N'SMT', CAST(25.00 AS Decimal(6, 2)), 19)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (6, N'ANZ', CAST(48.00 AS Decimal(6, 2)), 12)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (6, N'SMT', CAST(36.00 AS Decimal(6, 2)), 12)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (7, N'HRO', CAST(600.00 AS Decimal(6, 2)), 13)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (8, N'ANZ', CAST(840.00 AS Decimal(6, 2)), 13)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (9, N'ANZ', CAST(20.00 AS Decimal(6, 2)), 19)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (101, N'PRC', CAST(88.00 AS Decimal(6, 2)), 5)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (101, N'SHM', CAST(68.00 AS Decimal(6, 2)), 5)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (102, N'PRC', CAST(480.00 AS Decimal(6, 2)), 15)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (102, N'SHM', CAST(220.00 AS Decimal(6, 2)), 15)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (103, N'PRC', CAST(20.00 AS Decimal(6, 2)), 19)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (104, N'PRC', CAST(58.00 AS Decimal(6, 2)), 19)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (105, N'PRC', CAST(53.00 AS Decimal(6, 2)), 20)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (105, N'SHM', CAST(80.00 AS Decimal(6, 2)), 20)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (106, N'PRC', CAST(23.00 AS Decimal(6, 2)), 19)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (107, N'PRC', CAST(70.00 AS Decimal(6, 2)), 20)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (108, N'SHM', CAST(45.00 AS Decimal(6, 2)), 19)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (109, N'PRC', CAST(30.00 AS Decimal(6, 2)), 17)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (109, N'SHM', CAST(200.00 AS Decimal(6, 2)), 14)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (110, N'ANZ', CAST(244.00 AS Decimal(6, 2)), 16)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (110, N'HRO', CAST(260.00 AS Decimal(6, 2)), 16)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (110, N'HSK', CAST(308.00 AS Decimal(6, 2)), 16)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (110, N'PRC', CAST(236.00 AS Decimal(6, 2)), 16)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (110, N'SHM', CAST(228.00 AS Decimal(6, 2)), 16)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (111, N'SHM', CAST(499.99 AS Decimal(6, 2)), 18)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (112, N'SHM', CAST(549.00 AS Decimal(6, 2)), 18)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (113, N'SHM', CAST(685.90 AS Decimal(6, 2)), 18)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (114, N'PRC', CAST(120.00 AS Decimal(6, 2)), 7)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (201, N'ANZ', CAST(75.00 AS Decimal(6, 2)), 19)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (201, N'KAR', CAST(90.00 AS Decimal(6, 2)), 19)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (201, N'NKL', CAST(37.50 AS Decimal(6, 2)), 19)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (202, N'KAR', CAST(230.00 AS Decimal(6, 2)), 10)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (202, N'NKL', CAST(174.00 AS Decimal(6, 2)), 10)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (203, N'NKL', CAST(670.00 AS Decimal(6, 2)), 10)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (204, N'KAR', CAST(45.00 AS Decimal(6, 2)), 19)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (205, N'ANZ', CAST(312.00 AS Decimal(6, 2)), 13)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (205, N'HRO', CAST(312.00 AS Decimal(6, 2)), 13)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (205, N'NKL', CAST(312.00 AS Decimal(6, 2)), 13)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (301, N'ANZ', CAST(95.00 AS Decimal(6, 2)), 19)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (301, N'HRO', CAST(42.50 AS Decimal(6, 2)), 19)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (301, N'KAR', CAST(87.00 AS Decimal(6, 2)), 19)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (301, N'NKL', CAST(97.00 AS Decimal(6, 2)), 19)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (301, N'PRC', CAST(75.00 AS Decimal(6, 2)), 19)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (301, N'SHM', CAST(102.00 AS Decimal(6, 2)), 19)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (302, N'HRO', CAST(4.50 AS Decimal(6, 2)), 19)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (302, N'KAR', CAST(5.00 AS Decimal(6, 2)), 19)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (303, N'KAR', CAST(36.00 AS Decimal(6, 2)), 3)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (303, N'PRC', CAST(48.00 AS Decimal(6, 2)), 3)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (304, N'ANZ', CAST(170.00 AS Decimal(6, 2)), 1)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (304, N'HRO', CAST(280.00 AS Decimal(6, 2)), 1)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (305, N'HRO', CAST(48.00 AS Decimal(6, 2)), 16)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (306, N'PRC', CAST(160.00 AS Decimal(6, 2)), 19)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (306, N'SHM', CAST(190.00 AS Decimal(6, 2)), 19)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (307, N'PRC', CAST(250.00 AS Decimal(6, 2)), 19)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (308, N'PRC', CAST(280.00 AS Decimal(6, 2)), 19)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (309, N'HRO', CAST(40.00 AS Decimal(6, 2)), 11)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (309, N'SHM', CAST(40.00 AS Decimal(6, 2)), 11)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (310, N'ANZ', CAST(84.00 AS Decimal(6, 2)), 9)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (310, N'SHM', CAST(80.00 AS Decimal(6, 2)), 8)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (311, N'SHM', CAST(48.00 AS Decimal(6, 2)), 4)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (312, N'HRO', CAST(72.00 AS Decimal(6, 2)), 2)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (312, N'SHM', CAST(96.00 AS Decimal(6, 2)), 2)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (313, N'ANZ', CAST(60.00 AS Decimal(6, 2)), 2)
INSERT [dbo].[products] ([stock_num], [manu_code], [unit_price], [unit_code]) VALUES (313, N'SHM', CAST(72.00 AS Decimal(6, 2)), 2)
INSERT [dbo].[state] ([state], [sname]) VALUES (N'AK', N'Alaska')
INSERT [dbo].[state] ([state], [sname]) VALUES (N'AL', N'Alabama')
INSERT [dbo].[state] ([state], [sname]) VALUES (N'AR', N'Arkansas')
INSERT [dbo].[state] ([state], [sname]) VALUES (N'AZ', N'Arizona')
INSERT [dbo].[state] ([state], [sname]) VALUES (N'CA', N'California')
INSERT [dbo].[state] ([state], [sname]) VALUES (N'CO', N'Colorado')
INSERT [dbo].[state] ([state], [sname]) VALUES (N'CT', N'Connecticut')
INSERT [dbo].[state] ([state], [sname]) VALUES (N'DC', N'D.C.')
INSERT [dbo].[state] ([state], [sname]) VALUES (N'DE', N'Delaware')
INSERT [dbo].[state] ([state], [sname]) VALUES (N'FL', N'Florida')
INSERT [dbo].[state] ([state], [sname]) VALUES (N'GA', N'Georgia')
INSERT [dbo].[state] ([state], [sname]) VALUES (N'HI', N'Hawaii')
INSERT [dbo].[state] ([state], [sname]) VALUES (N'IA', N'Iowa')
INSERT [dbo].[state] ([state], [sname]) VALUES (N'ID', N'Idaho')
INSERT [dbo].[state] ([state], [sname]) VALUES (N'IL', N'Illinois')
INSERT [dbo].[state] ([state], [sname]) VALUES (N'IN', N'Indiana')
INSERT [dbo].[state] ([state], [sname]) VALUES (N'KS', N'Kansas')
INSERT [dbo].[state] ([state], [sname]) VALUES (N'KY', N'Kentucky')
INSERT [dbo].[state] ([state], [sname]) VALUES (N'LA', N'Louisiana')
INSERT [dbo].[state] ([state], [sname]) VALUES (N'MA', N'Massachusetts')
INSERT [dbo].[state] ([state], [sname]) VALUES (N'MD', N'Maryland')
INSERT [dbo].[state] ([state], [sname]) VALUES (N'ME', N'Maine')
INSERT [dbo].[state] ([state], [sname]) VALUES (N'MI', N'Michigan')
INSERT [dbo].[state] ([state], [sname]) VALUES (N'MN', N'Minnesota')
INSERT [dbo].[state] ([state], [sname]) VALUES (N'MO', N'Missouri')
INSERT [dbo].[state] ([state], [sname]) VALUES (N'MS', N'Mississippi')
INSERT [dbo].[state] ([state], [sname]) VALUES (N'MT', N'Montana')
INSERT [dbo].[state] ([state], [sname]) VALUES (N'NC', N'North Carolina')
INSERT [dbo].[state] ([state], [sname]) VALUES (N'ND', N'North Dakota')
INSERT [dbo].[state] ([state], [sname]) VALUES (N'NE', N'Nebraska')
INSERT [dbo].[state] ([state], [sname]) VALUES (N'NH', N'New Hampshire')
INSERT [dbo].[state] ([state], [sname]) VALUES (N'NJ', N'New Jersey')
INSERT [dbo].[state] ([state], [sname]) VALUES (N'NM', N'New Mexico')
INSERT [dbo].[state] ([state], [sname]) VALUES (N'NV', N'Nevada')
INSERT [dbo].[state] ([state], [sname]) VALUES (N'NY', N'New York')
INSERT [dbo].[state] ([state], [sname]) VALUES (N'OH', N'Ohio')
INSERT [dbo].[state] ([state], [sname]) VALUES (N'OK', N'Oklahoma')
INSERT [dbo].[state] ([state], [sname]) VALUES (N'OR', N'Oregon')
INSERT [dbo].[state] ([state], [sname]) VALUES (N'PA', N'Pennsylvania')
INSERT [dbo].[state] ([state], [sname]) VALUES (N'PR', N'Puerto Rico')
INSERT [dbo].[state] ([state], [sname]) VALUES (N'RI', N'Rhode Island')
INSERT [dbo].[state] ([state], [sname]) VALUES (N'SC', N'South Carolina')
INSERT [dbo].[state] ([state], [sname]) VALUES (N'SD', N'South Dakota')
INSERT [dbo].[state] ([state], [sname]) VALUES (N'TN', N'Tennessee')
INSERT [dbo].[state] ([state], [sname]) VALUES (N'TX', N'Texas')
INSERT [dbo].[state] ([state], [sname]) VALUES (N'UT', N'Utah')
INSERT [dbo].[state] ([state], [sname]) VALUES (N'VA', N'Virginia')
INSERT [dbo].[state] ([state], [sname]) VALUES (N'VT', N'Vermont')
INSERT [dbo].[state] ([state], [sname]) VALUES (N'WA', N'Washington')
INSERT [dbo].[state] ([state], [sname]) VALUES (N'WI', N'Wisconsin')
INSERT [dbo].[state] ([state], [sname]) VALUES (N'WV', N'West Virginia')
INSERT [dbo].[state] ([state], [sname]) VALUES (N'WY', N'Wyoming')
SET IDENTITY_INSERT [dbo].[units] ON 

INSERT [dbo].[units] ([unit_code], [unit], [unit_descr]) VALUES (1, N'box ', N'10/box')
INSERT [dbo].[units] ([unit_code], [unit], [unit_descr]) VALUES (2, N'box ', N'12/box')
INSERT [dbo].[units] ([unit_code], [unit], [unit_descr]) VALUES (3, N'box ', N'24 pairs/box')
INSERT [dbo].[units] ([unit_code], [unit], [unit_descr]) VALUES (4, N'box ', N'4 pairs/box')
INSERT [dbo].[units] ([unit_code], [unit], [unit_descr]) VALUES (5, N'box ', N'4/box')
INSERT [dbo].[units] ([unit_code], [unit], [unit_descr]) VALUES (6, N'case', N'10 gloves/case')
INSERT [dbo].[units] ([unit_code], [unit], [unit_descr]) VALUES (7, N'case', N'10 pairs/case')
INSERT [dbo].[units] ([unit_code], [unit], [unit_descr]) VALUES (8, N'case', N'10/case')
INSERT [dbo].[units] ([unit_code], [unit], [unit_descr]) VALUES (9, N'case', N'12/case')
INSERT [dbo].[units] ([unit_code], [unit], [unit_descr]) VALUES (10, N'case', N'2 sets/case')
INSERT [dbo].[units] ([unit_code], [unit], [unit_descr]) VALUES (11, N'case', N'20/case')
INSERT [dbo].[units] ([unit_code], [unit], [unit_descr]) VALUES (12, N'case', N'24 cans/case')
INSERT [dbo].[units] ([unit_code], [unit], [unit_descr]) VALUES (13, N'case', N'24/case')
INSERT [dbo].[units] ([unit_code], [unit], [unit_descr]) VALUES (14, N'case', N'4 pairs/case')
INSERT [dbo].[units] ([unit_code], [unit], [unit_descr]) VALUES (15, N'case', N'4 sets/case')
INSERT [dbo].[units] ([unit_code], [unit], [unit_descr]) VALUES (16, N'case', N'4/case')
INSERT [dbo].[units] ([unit_code], [unit], [unit_descr]) VALUES (17, N'case', N'6 pairs/case')
INSERT [dbo].[units] ([unit_code], [unit], [unit_descr]) VALUES (18, N'each', N'')
INSERT [dbo].[units] ([unit_code], [unit], [unit_descr]) VALUES (19, N'each', N'each')
INSERT [dbo].[units] ([unit_code], [unit], [unit_descr]) VALUES (20, N'pair', N'pair')
SET IDENTITY_INSERT [dbo].[units] OFF
ALTER TABLE [dbo].[catalog]  WITH CHECK ADD FOREIGN KEY([stock_num], [manu_code])
REFERENCES [dbo].[products] ([stock_num], [manu_code])

ALTER TABLE [dbo].[cust_calls]  WITH CHECK ADD FOREIGN KEY([call_code])
REFERENCES [dbo].[call_type] ([call_code])

ALTER TABLE [dbo].[cust_calls]  WITH CHECK ADD FOREIGN KEY([customer_num])
REFERENCES [dbo].[customer] ([customer_num])

ALTER TABLE [dbo].[customer]  WITH CHECK ADD FOREIGN KEY([customer_num_referedBy])
REFERENCES [dbo].[customer] ([customer_num])

ALTER TABLE [dbo].[customer]  WITH CHECK ADD FOREIGN KEY([state])
REFERENCES [dbo].[state] ([state])

ALTER TABLE [dbo].[items]  WITH CHECK ADD FOREIGN KEY([stock_num], [manu_code])
REFERENCES [dbo].[products] ([stock_num], [manu_code])

ALTER TABLE [dbo].[items]  WITH CHECK ADD FOREIGN KEY([stock_num], [manu_code])
REFERENCES [dbo].[products] ([stock_num], [manu_code])

ALTER TABLE [dbo].[items]  WITH CHECK ADD FOREIGN KEY([order_num])
REFERENCES [dbo].[orders] ([order_num])

ALTER TABLE [dbo].[items]  WITH CHECK ADD FOREIGN KEY([order_num])
REFERENCES [dbo].[orders] ([order_num])

ALTER TABLE [dbo].[manufact]  WITH CHECK ADD FOREIGN KEY([state])
REFERENCES [dbo].[state] ([state])

ALTER TABLE [dbo].[orders]  WITH CHECK ADD FOREIGN KEY([customer_num])
REFERENCES [dbo].[customer] ([customer_num])

ALTER TABLE [dbo].[products]  WITH CHECK ADD FOREIGN KEY([manu_code])
REFERENCES [dbo].[manufact] ([manu_code])

ALTER TABLE [dbo].[products]  WITH CHECK ADD FOREIGN KEY([unit_code])
REFERENCES [dbo].[units] ([unit_code])

ALTER TABLE [dbo].[products]  WITH CHECK ADD  CONSTRAINT [FK_product_types] FOREIGN KEY([stock_num])
REFERENCES [dbo].[product_types] ([stock_num])

ALTER TABLE [dbo].[products] CHECK CONSTRAINT [FK_product_types]

