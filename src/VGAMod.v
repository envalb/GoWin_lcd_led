module VGAMod
(
    input                   CLK,
    input                   nRST,

    input                   PixelClk,

    output                  LCD_DE,
    output                  LCD_HSYNC,
    output                  LCD_VSYNC,

	output          [4:0]   LCD_B,
	output          [5:0]   LCD_G,
	output          [4:0]   LCD_R
);

    reg         [15:0]  PixelCount;
    reg         [15:0]  LineCount;

    //Параметры TFT 1024x600
	localparam      V_BackPorch = 16'd23; 
	localparam      V_Pluse 	= 16'd1; 
	localparam      HightPixel  = 16'd600;
	localparam      V_FrontPorch= 16'd1; 

	localparam      H_BackPorch = 16'd160; 
	localparam      H_Pluse 	= 16'd1; 
	localparam      WidthPixel  = 16'd1024; 
	localparam      H_FrontPorch= 16'd16;

    localparam      Width_bar   =   128;
    localparam      Hight_bar   =   0;
    reg         [15:0]  BarCount;
    
 
    localparam      PixelForHS  =   WidthPixel + H_BackPorch + H_FrontPorch + H_Pluse;  	
    localparam      LineForVS   =   HightPixel + V_BackPorch + V_FrontPorch + V_Pluse;

    always @(  posedge PixelClk or negedge nRST  )begin
        if( !nRST ) begin
            LineCount       <=  16'b0;    
            PixelCount      <=  16'b0;
            end
        else if(  PixelCount  ==  PixelForHS ) begin
            PixelCount      <=  16'b0;
            LineCount       <=  LineCount + 1'b1;
            end
        else if(  LineCount  == LineForVS  ) begin
            LineCount       <=  16'b0;
            PixelCount      <=  16'b0;
            end
        else
            PixelCount      <=  PixelCount + 1'b1;
    end

	reg			[9:0]  Data_R;
	reg			[9:0]  Data_G;
	reg			[9:0]  Data_B;

    always @(  posedge PixelClk or negedge nRST  )begin
        if( !nRST ) begin
			Data_R <= 9'b0;
			Data_G <= 9'b0;
			Data_B <= 9'b0;
            BarCount <=9'd5;
            end
        else begin
			end
	end

    assign  LCD_DE = (( PixelCount < WidthPixel ) && ( LineCount < HightPixel))  ? 1'b1 : 1'b0;
    assign  LCD_HSYNC = (( PixelCount >= WidthPixel + H_FrontPorch) && ( PixelCount <= WidthPixel + H_FrontPorch + H_Pluse)) ? 1'b1 : 1'b0;
    assign  LCD_VSYNC = (( LineCount  <=  HightPixel + V_FrontPorch) && ( LineCount  <= HightPixel + V_FrontPorch + V_Pluse )) ? 1'b1 : 1'b0;



    assign  LCD_R   =   (PixelCount<128*1 && LineCount >= Hight_bar)? 5'b11111 : 
                        (PixelCount<128*2 && LineCount >= Hight_bar ? 5'b11111 :    
                        (PixelCount<128*3 && LineCount >= Hight_bar ? 5'b00000 :   
                        (PixelCount<128*4 && LineCount >= Hight_bar ? 5'b00000 :    
                        (PixelCount<128*5 && LineCount >= Hight_bar ? 5'b11111 : 
                        (PixelCount<128*6 && LineCount >= Hight_bar ? 5'b11111 :    
                        (PixelCount<128*7 && LineCount >= Hight_bar ? 5'b00000 : 
                        (PixelCount<128*8 && LineCount >= Hight_bar ? 5'b00000 : 5'b00000 )))))));


    assign  LCD_G   =   (PixelCount<128*1 && LineCount >= Hight_bar)? 6'b111111 : 
                        (PixelCount<128*2 && LineCount >= Hight_bar ? 6'b111111 :    
                        (PixelCount<128*3 && LineCount >= Hight_bar ? 6'b111111 :   
                        (PixelCount<128*4 && LineCount >= Hight_bar ? 6'b111111 :    
                        (PixelCount<128*5 && LineCount >= Hight_bar ? 6'b000000 : 
                        (PixelCount<128*6 && LineCount >= Hight_bar ? 6'b000000 :    
                        (PixelCount<128*7 && LineCount >= Hight_bar ? 6'b000000 : 
                        (PixelCount<128*8 && LineCount >= Hight_bar ? 6'b000000 : 6'b000000 )))))));


    assign  LCD_B   =   (PixelCount<128*1 && LineCount >= Hight_bar)? 5'b11111 : 
                        (PixelCount<128*2 && LineCount >= Hight_bar ? 5'b00000 :    
                        (PixelCount<128*3 && LineCount >= Hight_bar ? 5'b11111 :   
                        (PixelCount<128*4 && LineCount >= Hight_bar ? 5'b00000 :    
                        (PixelCount<128*5 && LineCount >= Hight_bar ? 5'b11111 : 
                        (PixelCount<128*6 && LineCount >= Hight_bar ? 5'b00000 :    
                        (PixelCount<128*7 && LineCount >= Hight_bar ? 5'b11111 : 
                        (PixelCount<128*8 && LineCount >= Hight_bar ? 5'b00000 : 5'b00000 )))))));




endmodule
