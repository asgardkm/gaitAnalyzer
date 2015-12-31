function [Filtered] = FilterMe(DATA, Order, Amount)
%This function applies a butterworth filter
%   FORM:  [FilteredDATA] = FilterMe(DataVector, FilterOrder, Normalized Natural Frequency < 1)

[A, B] = butter(Order, Amount);
Filtered = filtfilt(A, B, DATA);

end

