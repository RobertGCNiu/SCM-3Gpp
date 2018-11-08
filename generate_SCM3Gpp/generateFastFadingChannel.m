function [H, delayChip] = generateFastFadingChannel() 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���ɿ�˥�ŵ�����    
% ���ܣ�ʹ��3GPP TR25.996��¼��SCM�ŵ�ģ�ͺ�SCM����,���ɿ�˥�ŵ�����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ����:  simConsts, �������ýṹ��
% �����H delayChip
%      1. H, ��˥�ŵ���[cellNum, Nr, Nt, 6, userNum]ά
%      2. delayChip, �����ӳ�[cellNum, userNum, 6]ά������ƬΪ��λ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

simConsts = simConfig();

%��ӵ�ǰ·���µ�������Ŀ¼
path = 'C:\Users\robert\Desktop\generate_ChannelInf-master\scm';
addpath(genpath(path));

%������ʼ��
NumTimeSamples = 350;                                         %ÿ����·��������
MsVelocity = simConsts.MsVelocity / 3.6;                    %�ƶ�̨����, m/s
chipRate = simConsts.chipRate;                              %����/������
userNum = simConsts.userNum;                                %�û���
cellNum = simConsts.cellNum;                                %С����
NumMsElements = simConsts.MS_antenna;                       %�ƶ�̨������
NumBsElements = simConsts.BS_antenna;                       %��վ������
bandWidth = simConsts.bandWidth;

%��������      
DelaySamplingInterval =   1 / (chipRate * 16);        %ʱ�Ӳ������/�ֱ���

%SCM��������
scmpar = scmparset;                                         %�������ã�Ĭ�ϲ�����·����ĺ���Ӱ˥��
scmpar.SampleDensity = 9;                                   %�����ܶȣ���λΪsample/half wavelength
% scmpar.UniformTimeSampling = 'yes';
scmpar.NumTimeSamples = NumTimeSamples;                     %��������
scmpar.DelaySamplingInterval = DelaySamplingInterval;       %�������
scmpar.NumBsElements = NumBsElements;                       %��վ��������
scmpar.NumMsElements = NumMsElements;                       %�ƶ�̨��������
scmpar.CenterFrequency = simConsts.fc;                      %�ز�Ƶ��
scmpar.Scenario = simConsts.Scenario;                       %����
scmpar.BsUrbanMacroAS = 'fifteen';                          %BS ƽ���Ƕ���չ 
%��·����
linkpar = linkparset(userNum);                              %��������
linkpar.MsVelocity = MsVelocity*ones(1, userNum);           %�ƶ�̨����, m/s
%���߲�������
antpar = antparset;                                         %���߻�������
antpar.BsElementPosition = simConsts.BsElementPosition;     %��վ���߼��
antpar.MsElementPosition = simConsts.MsElementPosition;     %�ƶ�̨���߼��

%�����ŵ���Ϣ
H = zeros(NumTimeSamples, NumMsElements, NumBsElements, 6, userNum);
delayChip = zeros(NumTimeSamples, userNum, 6);
[H1, delayChip1,  ~] =  scm(scmpar, linkpar, antpar);   %���ɸ�С���������û���SCM�ŵ�
for i = 1:NumTimeSamples    %NumTimeSamples/10Ϊ��֡��
    %     H1 = squeeze(mean(H1, 4));                              %���в�����ȡƽ��
    delayChip1 = round(delayChip1 * chipRate);              %��˥���ŵ��еĶྶ�ӳ٣���ת��Ϊ��Ƭ��
    H(i, :, :, :, :) = H1(:,:,:,i,:);
    delayChip(i, :, :) = delayChip1;
end
 
%���ŵ���Ϣ��ʱ�洢һ��
saveDir = 'H.mat';
save(saveDir,'H');






    
    
 
