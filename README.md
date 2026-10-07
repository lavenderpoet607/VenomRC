<h1>TWRP Device Tree untuk Samsung Galaxy A05 (SM-A055F)</h1>

<p>Device tree TWRP kustom untuk perangkat Samsung Galaxy A05 berbasis Android 15 (One UI 7.0) dengan chipset MediaTek Helio G85 (MT6769V).</p>

<h2>Spesifikasi Perangkat</h2>

<table>
  <tr>
    <th>Komponen</th>
    <th>Spesifikasi</th>
  </tr>
  <tr>
    <td>Model Perangkat</td>
    <td>Samsung Galaxy A05 (SM-A055F / a05)</td>
  </tr>
  <tr>
    <td>Chipset / SoC</td>
    <td>MediaTek Helio G85 (MT6769V)</td>
  </tr>
  <tr>
    <td>Arsitektur CPU</td>
    <td>ARM64 (arm64-v8a)</td>
  </tr>
  <tr>
    <td>Sistem Operasi</td>
    <td>Android 15 (One UI 7.0)</td>
  </tr>
  <tr>
    <td>Versi Kernel</td>
    <td>6.6.89 (android15-8-aba055FXXSHDZF1-4k)</td>
  </tr>
  <tr>
    <td>Build ID</td>
    <td>AP3A.240905.015.A2.A055FXXSHDZF1</td>
  </tr>
  <tr>
    <td>Ukuran Halaman (Page Size)</td>
    <td>4096 byte (4k)</td>
  </tr>
  <tr>
    <td>Resolusi Layar</td>
    <td>720 x 1600 piksel</td>
  </tr>
  <tr>
    <td>Tipe Partisi</td>
    <td>Dynamic Partitions (super)</td>
  </tr>
  <tr>
    <td>Skema Enkripsi</td>
    <td>File-Based Encryption v2 (FBEv2) + Metadata Encryption</td>
  </tr>
</table>

<h2>Cara Kompilasi Lokal</h2>

<p>Jalankan perintah berikut di lingkungan Ubuntu x86_64:</p>

<pre><code>mkdir -p ~/twrp
cd ~/twrp
repo init --depth=1 -u https://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp.git -b twrp-12.1
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j$(nproc --all)

git clone &lt;url-repo-ini&gt; device/samsung/a05

source build/envsetup.sh
export ALLOW_MISSING_DEPENDENCIES=true
lunch omni_a05-eng
mka recoveryimage -j$(nproc --all)
</code></pre>

<p>Hasil build tersimpan di <code>out/target/product/a05/recovery.img</code>.</p>

<h2>Pembuatan Paket Odin (recovery.tar)</h2>

<p>Samsung Odin membutuhkan arsip tar tanpa kompresi:</p>

<pre><code>cd out/target/product/a05
tar -cvf recovery.tar recovery.img
sha256sum recovery.tar &gt; recovery.tar.sha256
</code></pre>

<h2>Panduan Flashing via Odin</h2>

<ol>
  <li>Aktifkan OEM Unlocking dan USB Debugging pada Developer Options di ponsel.</li>
  <li>Buka kunci bootloader perangkat melalui Download Mode (tahan Volume Atas dan Volume Bawah saat mencolokkan kabel USB ke PC).</li>
  <li>Siapkan berkas <code>vbmeta.img</code> yang telah dipatch dengan flag disable-verity dan disable-verification, atau gunakan file vbmeta kosong.</li>
  <li>Buka Odin3 v3.14.4 di komputer Windows.</li>
  <li>Matikan opsi <code>Auto Reboot</code> di tab Options pada Odin3.</li>
  <li>Masukkan berkas <code>recovery.tar</code> ke dalam slot <code>AP</code>.</li>
  <li>Masukkan berkas vbmeta kosong atau patched ke slot <code>USERDATA</code> atau sesuai slot pemetaan firmware.</li>
  <li>Klik tombol Start pada Odin hingga status menunjukkan <code>PASS</code>.</li>
  <li>Cabut kabel USB, lalu tekan dan tahan tombol Volume Bawah + Power untuk keluar dari Download Mode.</li>
  <li>Saat layar mati seketika, langsung pindahkan jari menekan Volume Atas + Power hingga logo Samsung muncul untuk masuk ke TWRP Recovery.</li>
</ol>
