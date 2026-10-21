# Ruang Kode deployment handoff

## Public beta

https://ruang-kode-learning-beta.muhammadmansuradam2.chatgpt.site

The Site is public: anyone with the link can open it without localhost or a development server.

## Static upload package

Use `ruang-kode-static-deploy.zip` when uploading to a static host such as Netlify, Vercel, Cloudflare Pages, GitHub Pages, cPanel, or ordinary web hosting.

1. Extract the archive.
2. Upload **all contents together**: `index.html` and the `assets` folder.
3. Configure the host to serve `index.html` for the root page.

The paths inside this package are relative, so the site can also run from a subfolder.

## Editable source package

Use `ruang-kode-full-source.zip` for development.

```bash
npm install
npm run dev
```

Create a new production build with:

```bash
npm run build
```

The static production files will be generated under `dist/client`.

## Demo accounts

- Student: `siswa@ruangkode.id` / `demo123`
- Teacher: `guru@ruangkode.id` / `demo123`
- Administrator: `admin@ruangkode.id` / `demo123`

This beta stores progress and edits in each browser's local storage. Different devices therefore receive independent demonstration data until the production backend is connected.
