clc;
clear;
close all;
%GENERAtion of bits
% Number of bits
N = 1e5;              % 100,000 bits 

% Generate random bits (0s and 1s)
bits = randi([0 1], N, 1);  % randi([0 1], N, 1) creates an N×1 column vector
                            % Each element is randomly either 0 or 1
                            % This represents the digital information bits to be transmitted

%% STEP-2: BPSK Modulation

% BPSK mapping:
% bit 0 -> -1
% bit 1 -> +1

bpsk_symbols = 2*bits - 1;

%% STEP-3: AWGN Channel (y = s + n)

% Choose Signal-to-Noise Ratio (SNR) in dB
SNR_dB = 5;                 

% Convert SNR from dB to linear scale
SNR_linear = 10^(SNR_dB/10);

% Noise variance for BPSK (signal power = 1)
noise_variance = 1/(2*SNR_linear);

% Generate AWGN noise (Gaussian, zero mean)
noise = sqrt(noise_variance) * randn(size(bpsk_symbols));

% Received signal after channel (y = s + n)
rx_signal = bpsk_symbols + noise;

%% STEP-4: BPSK Demodulation (Hard Decision)

% Initialize received bits
rx_bits = zeros(size(rx_signal));

% Decision rule:
% If received sample > 0, decide bit = 1
% Else decide bit = 0
rx_bits(rx_signal > 0) = 1;
rx_bits(rx_signal <= 0) = 0;

%% STEP-5A: BER Calculation for a single SNR

% Count bit errors
num_errors = sum(bits ~= rx_bits); %~= not equa to

% Calculate BER
BER = num_errors / length(bits);

disp(['BER at SNR = ', num2str(SNR_dB), ' dB is ', num2str(BER)]);


%% STEP-5B: BER vs SNR Curve for BPSK over AWGN

SNR_dB_range = 0:2:12;          % SNR values in dB
BER_sim = zeros(length(SNR_dB_range),1);

for k = 1:length(SNR_dB_range)
    
    SNR_dB = SNR_dB_range(k);
    SNR_linear = 10^(SNR_dB/10);
    
    % Noise variance for BPSK
    noise_variance = 1/(2*SNR_linear);
    
    % Generate noise
    noise = sqrt(noise_variance) * randn(size(bpsk_symbols));
    
    % Received signal
    rx_signal = bpsk_symbols + noise;
    
    % Demodulation
    rx_bits = zeros(size(rx_signal));
    rx_bits(rx_signal > 0) = 1;
    
    % BER calculation
    BER_sim(k) = sum(bits ~= rx_bits) / length(bits);
end

% Plot BER vs SNR
figure;
semilogy(SNR_dB_range, BER_sim, 'o-');
grid on;
xlabel('SNR (dB)');
ylabel('Bit Error Rate (BER)');
title('BER vs SNR for BPSK over AWGN Channel');







