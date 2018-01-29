import hddm
import os


filepath='/Users/nickhedger/Documents/EYETRACK_DATA/Choice/S_PILOT/S_PILOT_ddm.csv'
data = hddm.load_csv(filepath)

os.chdir(os.path.split(filepath)[0])

import matplotlib.pyplot as plt

data = hddm.utils.flip_errors(data)

fig = plt.figure()
ax = fig.add_subplot(111, xlabel='RT', ylabel='count', title='RT distributions')
for i, subj_data in data.groupby('subj_idx'):
    subj_data.rt.hist(bins=20, histtype='step', ax=ax)


m = hddm.HDDM(data)

m.find_starting_values()
# start drawing 7000 samples and discarding 5000 as burn-in
m.sample(2000, burn=20)


stats = m.gen_stats()
stats[stats.index.isin(['a_subj.1'])]


m.plot_posterior_predictive(figsize=(8, 8))
plt.title('fitted data')
plt.savefig('HDDM fit.pdf')

m_stim = hddm.HDDM(data, depends_on={'v': 'sc'})
m_stim.find_starting_values()
m_stim.sample(10000, burn=1000)

v_1, v_2 = m_stim.nodes_db.node[['v(1)', 'v(2)']]
hddm.analyze.plot_posterior_nodes([v_1, v_2])
plt.xlabel('drift-rate')
plt.ylabel('Posterior probability')
plt.title('Posterior of drift-rate group means')
plt.savefig('Intact v scrambled drift rate.pdf')


m_stim.plot_posterior_predictive(figsize=(14, 10))


m_reg = hddm.HDDMRegressor(data[data.sc==1],"v ~ socfix")

m_reg.sample(5000, burn=200)

fix = m_reg.nodes_db.node["v_socfix"]
hddm.analyze.plot_posterior_nodes([fix], bins=20)
plt.title('Gaze in social AOI on drift rate')
print "P(v_fix < 0) = ", (fix.trace() < 0).mean()
plt.savefig('Socfix.pdf')


