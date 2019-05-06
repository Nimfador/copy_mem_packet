module FSM_frame (iclk, ilen, ienable, ishift_reg, ost, odata_byte);
input iclk, ienable;//тактирующий сигнал и сигнал разрешения формирования пакета
input [10:0] ilen;//входная длина поля данных
input [31:0] ishift_reg;
output reg [2:0] ost;//состояние КА на выходе
output reg [7:0] odata_byte;//байт, передающийся в данный момент времени

reg [2:0] rcurst, rnextst;//текущее и следующее состояник КА
reg [10:0] count;//счетчик для перехода между состояниями
reg [10:0] rlendata;//переменная для длины поля данных
wire [31:0] rshift_reg;//сдвиговый регистор для формирования "случайных данных"
wire next_bit;//новый сформировавшийся бит

//для подсчета crc
reg [31:0] rcrc;// сама контрольная сумма
integer i=7;//просто счетчик
wire wtemp_bit;//временная переменная для разворота битов
reg [7:0] rcrnull;

//state of FSM
localparam [2:0] stIGP=3'b0, stPREAMBLE=3'b1, stSFD=3'b10, stDADDR=3'b11, stSADDR=3'b100, stLENTYPE=3'b101, stDATA=3'b110, stFCS = 3'b111;
localparam [3:0] lPAUSE = 12;//задержка между пакетиками
localparam [31:0] lCRC32 = 32'h04C11DB7;//пораждающий полинмос

 function [31:0] nextCRC32_D8;

    input [7:0] Data;
    input [31:0] crc;
    reg [7:0] d;
    reg [31:0] c;
    reg [31:0] newcrc;
  begin
    d = Data;
    c = crc;

    newcrc[0] = d[6] ^ d[0] ^ c[24] ^ c[30];
    newcrc[1] = d[7] ^ d[6] ^ d[1] ^ d[0] ^ c[24] ^ c[25] ^ c[30] ^ c[31];
    newcrc[2] = d[7] ^ d[6] ^ d[2] ^ d[1] ^ d[0] ^ c[24] ^ c[25] ^ c[26] ^ c[30] ^ c[31];
    newcrc[3] = d[7] ^ d[3] ^ d[2] ^ d[1] ^ c[25] ^ c[26] ^ c[27] ^ c[31];
    newcrc[4] = d[6] ^ d[4] ^ d[3] ^ d[2] ^ d[0] ^ c[24] ^ c[26] ^ c[27] ^ c[28] ^ c[30];
    newcrc[5] = d[7] ^ d[6] ^ d[5] ^ d[4] ^ d[3] ^ d[1] ^ d[0] ^ c[24] ^ c[25] ^ c[27] ^ c[28] ^ c[29] ^ c[30] ^ c[31];
    newcrc[6] = d[7] ^ d[6] ^ d[5] ^ d[4] ^ d[2] ^ d[1] ^ c[25] ^ c[26] ^ c[28] ^ c[29] ^ c[30] ^ c[31];
    newcrc[7] = d[7] ^ d[5] ^ d[3] ^ d[2] ^ d[0] ^ c[24] ^ c[26] ^ c[27] ^ c[29] ^ c[31];
    newcrc[8] = d[4] ^ d[3] ^ d[1] ^ d[0] ^ c[0] ^ c[24] ^ c[25] ^ c[27] ^ c[28];
    newcrc[9] = d[5] ^ d[4] ^ d[2] ^ d[1] ^ c[1] ^ c[25] ^ c[26] ^ c[28] ^ c[29];
    newcrc[10] = d[5] ^ d[3] ^ d[2] ^ d[0] ^ c[2] ^ c[24] ^ c[26] ^ c[27] ^ c[29];
    newcrc[11] = d[4] ^ d[3] ^ d[1] ^ d[0] ^ c[3] ^ c[24] ^ c[25] ^ c[27] ^ c[28];
    newcrc[12] = d[6] ^ d[5] ^ d[4] ^ d[2] ^ d[1] ^ d[0] ^ c[4] ^ c[24] ^ c[25] ^ c[26] ^ c[28] ^ c[29] ^ c[30];
    newcrc[13] = d[7] ^ d[6] ^ d[5] ^ d[3] ^ d[2] ^ d[1] ^ c[5] ^ c[25] ^ c[26] ^ c[27] ^ c[29] ^ c[30] ^ c[31];
    newcrc[14] = d[7] ^ d[6] ^ d[4] ^ d[3] ^ d[2] ^ c[6] ^ c[26] ^ c[27] ^ c[28] ^ c[30] ^ c[31];
    newcrc[15] = d[7] ^ d[5] ^ d[4] ^ d[3] ^ c[7] ^ c[27] ^ c[28] ^ c[29] ^ c[31];
    newcrc[16] = d[5] ^ d[4] ^ d[0] ^ c[8] ^ c[24] ^ c[28] ^ c[29];
    newcrc[17] = d[6] ^ d[5] ^ d[1] ^ c[9] ^ c[25] ^ c[29] ^ c[30];
    newcrc[18] = d[7] ^ d[6] ^ d[2] ^ c[10] ^ c[26] ^ c[30] ^ c[31];
    newcrc[19] = d[7] ^ d[3] ^ c[11] ^ c[27] ^ c[31];
    newcrc[20] = d[4] ^ c[12] ^ c[28];
    newcrc[21] = d[5] ^ c[13] ^ c[29];
    newcrc[22] = d[0] ^ c[14] ^ c[24];
    newcrc[23] = d[6] ^ d[1] ^ d[0] ^ c[15] ^ c[24] ^ c[25] ^ c[30];
    newcrc[24] = d[7] ^ d[2] ^ d[1] ^ c[16] ^ c[25] ^ c[26] ^ c[31];
    newcrc[25] = d[3] ^ d[2] ^ c[17] ^ c[26] ^ c[27];
    newcrc[26] = d[6] ^ d[4] ^ d[3] ^ d[0] ^ c[18] ^ c[24] ^ c[27] ^ c[28] ^ c[30];
    newcrc[27] = d[7] ^ d[5] ^ d[4] ^ d[1] ^ c[19] ^ c[25] ^ c[28] ^ c[29] ^ c[31];
    newcrc[28] = d[6] ^ d[5] ^ d[2] ^ c[20] ^ c[26] ^ c[29] ^ c[30];
    newcrc[29] = d[7] ^ d[6] ^ d[3] ^ c[21] ^ c[27] ^ c[30] ^ c[31];
    newcrc[30] = d[7] ^ d[4] ^ c[22] ^ c[28] ^ c[31];
    newcrc[31] = d[5] ^ c[23] ^ c[29];
    nextCRC32_D8 = newcrc;
  end
  endfunction



//функция расчета очередного бита контрольной суммы
function [31:0] sdvig;
input reg [31:0] reg_in;//текущее значение crc
input reg data_bit;//новый бит данных, записываемые в crc
input reg curbit;//выдвигаемый бит данных
begin
sdvig = {reg_in[30:0],data_bit};
if (curbit) begin
	sdvig=sdvig^lCRC32;
end
end
endfunction 

//инициализация некоторых значений
initial begin
    count <= 'b0;//счетчик в 0
    rcurst <= stIGP;//начальное состояние КА
    rcrc <= 0;//все биты crc в нули
    rlendata <= 0;
    rcrnull<=0;
end
always @(posedge iclk) 
begin 
    //для кажого состояния КА определим следующее состояние
    case (rcurst)
        stIGP       : rnextst = stPREAMBLE;
        stPREAMBLE  : rnextst = stSFD;
        stSFD       : rnextst = stDADDR;
        stDADDR     : rnextst = stSADDR;
        stSADDR     : rnextst = stLENTYPE;
        stLENTYPE   : rnextst = stDATA;
        stDATA      : rnextst = stFCS;
        stFCS       : rnextst = stIGP;
    endcase
end
//расчет следующего бита 
assign next_bit = rshift_reg[31] ^
                rshift_reg[30] ^rshift_reg[29] ^
                rshift_reg[27] ^rshift_reg[25] ^
                rshift_reg[0];
assign rshift_reg = ishift_reg;
//�������� ���� ��� ���������� ��������
always @(posedge iclk) begin 

    //переход в состояния КА
    case (rcurst)
        stIGP:
        if(ienable & count>lPAUSE-2)begin
            rcurst<=rnextst;
            count<=0; 
        end
        else begin
            count <= count + 1;
        end
        stPREAMBLE: begin
            if (count < 6)
                count <= count + 1;
            else begin
                rcurst<=rnextst;
                count<=0;
            end
        end
        stSFD: begin
                rcurst<=rnextst;
                count<=0;
        end
        stDADDR: begin
            if (count < 5)
                count <= count + 1;
            else begin
                rcurst<=rnextst;
                count<=0;
            end
        end
        stSADDR: begin
            if (count < 5)
                count <= count + 1;
            else begin
                rcurst<=rnextst;
                count<=0;
            end
        end
        stLENTYPE:begin
            if (count < 1)
                count <= count + 1;
            else begin
                rcurst<=rnextst;
                rlendata <= ilen;
                count<=0;
            end
        end
        stDATA: begin
			odata_byte<=rshift_reg[7:0];//формирование нового байта данных
            if (rlendata > 1) begin
                rlendata <= rlendata-1;
            end
            else begin
                rcurst<=rnextst;
            end
            rcrc<=nextCRC32_D8(rcrc,rshift_reg[7:0]);
            //Подсчет crc (порядок бит в байте обратный)
            //for (i=0; i<8;i=i+1) begin
                    //rcrc = sdvig (rcrc,rshift_reg[i],rcrc[31]);
            //end
        end

        stFCS: begin
        rcrc<=nextCRC32_D8(rcrc,rcrnull);
            if (count < 3)
                count <= count + 1;
            else begin
                //for (i=0;i<16;i=i+1) begin
                  //  rcrc[i]<=~rcrc[31-i];
                    //rcrc[31-i]<=~rcrc[i];
                //end 
            rcurst<=rnextst;
            count<=0;
            end
        end
    endcase
end
always @(posedge iclk ) begin
  ost <=rcurst;
end
endmodule 