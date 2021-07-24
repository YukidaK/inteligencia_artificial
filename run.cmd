set $PIP=pip
set $PYTHON=python3

echo %$PYTHON%

rem  # Create virtual environment
rem -r venv\Scripts\activate.bat

rem  # Install dependencies
rem %$PIP% install -r requirements.txt

rem  # Extract files
rem unzip -o -d data/ data/audio_train.zip
rem unzip -o -d data/ data/audio_test.zip

rem  # Trim leading and trailing silence
rem %$PYTHON% 01-save-trimmed-wavs.py

rem  # Compute Log Mel-Spectrograms
rem %$PYTHON% 02-compute-mel-specs.py

rem  # Compute summary metrics of various spectral and time based features
rem %$PYTHON% 03-compute-summary-feats.py

rem  # Compute PCA features over the summary metrics from previous script
rem %$PYTHON% 04-pca.py

rem  # Divide the training data into 10 (stratified by label) folds
rem %$PYTHON% 05-ten-folds.py

rem  # Train only the part of the model, that depends on the Log Mel-Spec features (10 folds)
for (( FOLD=0; FOLD<=9; FOLD+=1 )); do
  %$PYTHON% 06-train-model-only-mel.py %$FOLD%
done

rem  # Train the full model, after loading weights from the mel-only model from previous script (10 folds)
for (( FOLD=0; FOLD<=9; FOLD+=1 )); do
  %$PYTHON% 07-train-model-mel-and-pca.py %$FOLD%
done

rem  # Generate predictions
%$PYTHON% 08-generate-predictions.py
