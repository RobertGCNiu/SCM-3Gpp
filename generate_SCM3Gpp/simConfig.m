function simConsts = simConfig()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ����ϵͳ���ú���    
% ���ܣ�ʵ�ַ���ϵͳ�������� (����)   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% ���룺��                               
% ��������ò����ṹ��                    
% ʹ��ʾ����simConsts = simConfig()      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%���ֶ���������
simConsts = struct('userPerCell', 10, ...           %ÿС���û���              
                   'bandWidth', 10e6, ...           %����     Hz
                   'interSiteDist', 500, ...    	%��վ���ISD   m
                   'BS_antenna', 4, ...             %��վ�������߸��� 
                   'MS_antenna', 1, ...             %UE�������߸���                
                   'fc', 2e9, ...                   %�ز�Ƶ��   Hz
                   'Scenario', 'urban_macro', ...   %���滷��
                   'BsElementPosition', 5, ...      %��վ���߼�����Բ���Ϊ��λ�� һ��ȡ 4 - 10
                   'MsElementPosition', 0.5, ...    %�ƶ�̨���߼�����Բ���ά��λ
                   'HARQ_num', 0, ...               %�ش�����
                   'allocateRbNum', 5, ...          %ÿ�ε��ȷ����RB��
                   'MS_TX_MAX_Power', 23, ...       %�ƶ�̨����书�� dBm
                   'MsVelocity', 30, ...             %�ƶ�̨����  km/h 300/250/200/150/100/50/0     
                   'thermalNoise', -174, ...        %�������� dBm/Hz
                   'BsNoiseFigure', 5, ....         %��վ���ն�����ϵ���� dB
                    ...
                    ... %�����ǵ��ȵĲ���
                    'utility', 'PF', ...            %Ч�ú�����maxCI, PF, RR, deltaR
                    'fairFactor', 1, ...            %PF�еĹ�ƽϵ��
                    'maxRbGroup', 5, ...            %ÿ���û��ܱ���������RB Group��
                    ...
                    ... %���������й��ʿ��ƵĲ��� 
                    'P0', -60, ....                 %�ο����ʣ� dBm  
                    'alpha', 0.6, ...               %������
                    ...
                    ... %coordinate set 
                    'setScheme', '1', ...
                    ...
                    ... %�������ŵ�ģ��
                    'channelModel', 'ITU'...        %�ŵ�ģ�ͣ�ITUģ�ͻ�3gpp case 1
                 );
 
             
             
simConsts.p=15;                %��ʱ�Ӵ�Сһ��            
             
             
             
%���²��������ֶ�����
simConsts.siteNum = 19;                             %��վ����
simConsts.sectorPerSite = 3;                        %ÿ����վ��������С��������

%�����վ���Ϸ���У��
supportSiteNum = [1, 7,19,37,61,91,127,169,217,271,331]; 
if ~find(supportSiteNum == simConsts.siteNum)
    error('wrong site number!');
end
                           
%�������ʡ�FFT������RB���Ķ�Ӧ��ϵ
table = [                                               ...
           [1.4,  3,    5,   10,   15,   20]*1e6;       ...     %����
           [0.5, 1,    2,   4,    6,    8]*3.84e6;      ...     %����
           128,  256,  512, 1024, 1536, 2048;           ...     %FFT��
           6,    15,   25,  50,   75,   100;            ...     %RB��
           ];  
       
index = table(1,:) == simConsts.bandWidth;

%����Ϸ���У��
if(sum(index) == 0 )
    error('wrong band width');
end

chipRate = table(2, index);                        
fftSize = table(3, index);
rbNum = table(4, index);
simConsts.fftSize = fftSize;                        %FFT���� 
simConsts.chipRate = chipRate;                      %����
simConsts.rbNum  = rbNum;                           %RB(resouce block)��


simConsts.siteWrapNum = simConsts.siteNum * 7;      %���ƺ�Ļ�վ��
simConsts.cellNum = simConsts.siteNum * 3;          %С����
simConsts.cellWrapNum = simConsts.cellNum * 7;      %���ƺ��С����
simConsts.userNum = simConsts.userPerCell * simConsts.cellNum;  %�û���
simConsts.userWrapNum = simConsts.userNum * 7;                  %���ƺ���û���

simConsts.rbGroupNum = simConsts.rbNum / simConsts.allocateRbNum;