# Nasa Gas Chromatography

 DrivenData competition [Mass Spectometry 2: Gas Chromatography](https://www.drivendata.org/competitions/97/nasa-mars-gcms/page/519/).

## Data source

The data for this challenge comes from laboratory instruments at NASA's Goddard Space Flight Center that are operated by the Sample Analysis at Mars (SAM) science team. SAM is an instrument suite aboard the Curiosity rover on Mars. The data was collected by commercially manufactured instruments that have been configured as SAM analogs at Goddard.

## Training data

For this competition gas chromatography (GC) column temperature data is not available. Also, data tagged as derivatized was certainly submitted to the process but it is unsure (and mostly unlikely) whether the untagged rows were derivatized or not. Data signals are:

- `time` - Time in seconds since start of data collection.
- `mass` - Mass-to-charge ratio (m/z) of ion being measured.
- `intensity` - Rate of ions detected, per second.

## Submission data

Other than the `sample_id`, the following families of compounds are to be identified:

- `aromatic`
- `hydrocarbon`
- `carboxylic_acid`
- `nitrogen_bearing_compound`
- `chlorine_bearing_compound`
- `sulfur_bearing_compound`
- `alcohol`
- `other_oxygen_bearing_compound`
- `mineral`

## Understanding the data

Some notes on how scientists typically interpret the GCMS data:

- In chemical analysis, it is common to compare the relative amounts of different substances (e.g., the chemical reaction [2H2O → 2H2 + O2] says two moles of water becomes two moles of molecular hydrogen and one mole of molecular oxygen). Accordingly, scientists will typically interpret mass spectrometry intensities collected from one sample in a relative way. Sometimes, mass spectra are normalized as "relative intensity" from 0 to 100 with the highest intensity value normalized to 100. (Note that this normalization should happen after background subtraction, discussed later in this section.)

- As previously discussed, peaks in ion intensities indicate an increase of the respective ions. Scientists typically look for known combinations of certain ions in certain ratios as evidence of certain fragments that derive from a compound as it elutes from the GC. The combination of ions that elute over a certain period of time is often integrated to get the highest quality mass spectra, which then can be used to identify the compounds.

  - Ions of a given m/z may have more than one peak in one GCMS run. This means that there were different compounds that contain that ion fragment that elute at different times eventually leading to that ion being detected.
  - It can be possible that ions from a given m/z result from more than one compound. For example, carbon dioxide (CO2), carbon monoxide (CO), and nitrogen gas (N2) all have major ions or fragments that appear at m/z 28. If a sample releases multiple gases (or there is atmospheric background), scientists have to separate out the different contributions when analyzing the data.
  - Scientists will often integrate the intensity curve in the time domain for a given m/z value when considering how much of that ion was measured in the GCMS run. The integration turns the intensity from a time series of rate values (e.g., counts per second) to a quantity (e.g., counts). In some cases, the counts values can be used to determine the absolute intensity.

- Helium (He) is used as a carrier gas in all GCMS runs in this competition. That means the presence of helium is not a meaningful signal in the classification task. Helium ions will typically show up in the data as ions detected with an m/z value of 4.0 and are usually disregarded, along with most ions with mass values of less than 12. Most ions relevant to the detection of the label classes for this competition will be below 250, but there are some compounds in these experiments that will generate ions between 250 and 500.

- Some ions have a background presence in the gas passing through the mass spectrometer, as evidenced by a relatively constant non-zero intensity value over the entire run, across the temperature range. This can happen for various reasons, such as contamination from the atmosphere. Scientists typically subtract this background to clean the data.

  - Background intensities do not remain constant across the experimental run. More often, the background intensities increase as the temperature increases, but often do so non-linearly. The best way to subtract background intensities is to subtract the intensity value that immediately precedes or follows a peak.

## Performance metric

Performance is evaluated according to multilabel aggregated log loss. Log loss (a.k.a. logistic loss or cross-entropy loss) penalizes confident but incorrect predictions. It also rewards confidence scores that are well-calibrated probabilities, meaning that they accurately reflect the long-run probability of being correct. This is an error metric, so a lower value is better.

## Things to consider

- The role of derivatization over peak spread.
- Absence of real column temperature measurement.
- Background subtraction prior to normalization.
- Identify entries with a single compound.
- Maybe a common resampling could be used.
