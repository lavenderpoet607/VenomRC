<h1>Arsitektur dan Desain Teknis TWRP Samsung Galaxy A05</h1>

<p>Dokumen ini merangkum arsitektur partisi penyimpanan, konfigurasi storage dinamis, implementasi enkripsi File-Based Encryption v2, serta mitigasi proteksi bootloader dan Samsung Knox pada perangkat Samsung Galaxy A05 (SM-A055F / a05).</p>

<h2>1. Arsitektur Partisi MediaTek MT6769V</h2>

<p>Samsung Galaxy A05 menggunakan penyimpanan internal berbasis eMMC 5.1 dengan pengontrol storage MediaTek MSDC (11230000.msdc). Skema partisi fisik utama meliputi:</p>

<ul>
  <li><code>boot</code>: Berisi kernel Image versi 6.6.89, ramdisk stage 1, dan dtb terintegrasi (boot header v4, ukuran halaman 4096 byte).</li>
  <li><code>recovery</code>: Partisi mandiri terdedikasi untuk recovery ramdisk dan kernel recovery.</li>
  <li><code>dtbo</code>: Device Tree Blob Overlay untuk konfigurasi modul perangkat keras spesifik model A055F.</li>
  <li><code>vbmeta</code>, <code>vbmeta_system</code>: Header Android Verified Boot 2.0 penandatangan integritas partisi sistem.</li>
  <li><code>metadata</code>: Partisi tempat penyimpanan kunci enkripsi filesystem dan konfigurasi vold.</li>
  <li><code>sec_efs</code>: Konfigurasi modem, IMEI, kalibrasi radio frekuensi Samsung.</li>
  <li><code>nvram</code>, <code>nvdata</code>: Data NVRAM MediaTek (MAC address Wi-Fi, Bluetooth address, baseband).</li>
  <li><code>protect1</code>, <code>protect2</code>: Proteksi kalibrasi RF dan data operasional baseband MediaTek.</li>
  <li><code>super</code>: Kontainer penyimpanan dinamis yang menampung seluruh partisi logika OS.</li>
</ul>

<h2>2. Struktur Dynamic Partitions (Super)</h2>

<p>Samsung Galaxy A05 mengadopsi Dynamic Partitions (A-only dynamic partitions) di dalam kontainer partisi fisik <code>super</code> berukuran 9.126.805.504 byte (sekitar 8,5 GB).</p>

<p>Di dalam grup partisi <code>samsung_dynamic_partitions</code>, terdapat 5 partisi logika (logical partitions):</p>

<ul>
  <li><code>system</code>: Core OS framework Android 15 (mendukung format erofs dan ext4).</li>
  <li><code>vendor</code>: Driver biner dan HAL MediaTek MT6769V (erofs / ext4).</li>
  <li><code>product</code>: Modul aplikasi sistem dan overlay One UI 7.0 (erofs / ext4).</li>
  <li><code>system_ext</code>: Ekstensi library sistem AOSP tambahan (erofs / ext4).</li>
  <li><code>odm</code>: Kustomisasi pabrikan perangkat Samsung (erofs / ext4).</li>
</ul>

<p>TWRP mengakses partisi ini melalui pemetaan device-mapper (dm-linear) yang diaktifkan oleh library liblp selama tahap awal recovery boot.</p>

<h2>3. Enkripsi Penyimpanan: File-Based Encryption v2 (FBEv2)</h2>

<p>Penyimpanan data pengguna (<code>/data</code>) pada Android 15 diformat menggunakan filesystem F2FS dengan proteksi File-Based Encryption v2 (FBEv2):</p>

<ul>
  <li><strong>Algoritma Enkripsi:</strong> aes-256-xts untuk enkripsi konten file dan aes-256-cts untuk enkripsi nama file.</li>
  <li><strong>Inline Encryption:</strong> Hardware cryptographic engine MediaTek diaktifkan via parameter inlinecrypt_optimized.</li>
  <li><strong>Metadata Encryption:</strong> Menggunakan skema wrappedkey_v0 dengan direktori kunci berada di <code>/metadata/vold/metadata_encryption</code>.</li>
  <li><strong>Mount Stage:</strong> Partisi <code>metadata</code> di-mount di tahap awal (first_stage_mount) agar daemon vold dan komponen fscrypt dapat membaca master key sebelum mendekripsi userdata.</li>
  <li><strong>Kebijakan FSCRYPT:</strong> TWRP dikonfigurasi dengan flag <code>TW_USE_FSCRYPT_POLICY := 2</code> untuk mendukung FBEv2 Android 15.</li>
</ul>

<h2>4. Mitigasi Bootloader dan Samsung Knox</h2>

<p>Perangkat Samsung mengimplementasikan serangkaian pengamanan berbasis hardware dan software bootloader:</p>

<ul>
  <li><strong>Knox Warranty Void (0x1):</strong> Pembukaan kunci bootloader memicu eFuse hardware Knox. Nilai flag berubah permanen dari 0x0 menjadi 0x1. TWRP mengintegrasikan utility <code>resetprop</code> untuk mengubah properti runtime sistem (seperti <code>ro.boot.warranty_bit=0</code>) demi menjaga fungsionalitas komponen OS tertentu saat booting custom ROM.</li>
  <li><strong>Samsung VaultKeeper:</strong> Daemon proteksi bootloader Samsung yang memverifikasi integritas partisi saat boot normal. Jika recovery kustom terdeteksi tanpa patching, VaultKeeper dapat memicu reboot paksa atau penguncian FRP. Mitigasi dilakukan dengan mencegah eksekusi verifikasi integritas saat mode recovery aktif.</li>
  <li><strong>Android Verified Boot (AVB 2.0):</strong> Bootloader menolak booting kernel atau recovery kustom jika verifikasi hash vbmeta gagal. Pengguna wajib melakukan flash berkas vbmeta kosong atau patched dengan flag <code>--disable-verity --disable-verification</code> sebelum me-reboot ke TWRP.</li>
  <li><strong>Reboot Loop Prevention:</strong> Samsung stock ROM memulihkan stock recovery secara otomatis pada boot pertama jika skrip install-recovery.sh dijalankan. Di dalam TWRP, format /data atau modifikasi partisi sistem dapat menonaktifkan mekanisme pemulihan recovery bawaan tersebut.</li>
</ul>
