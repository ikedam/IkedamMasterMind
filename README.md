# MasterMind Web（作業中）

このリポジトリーは、既存の iOS 版 MasterMind をブラウザー上で完結するクライアントサイドアプリとして再構築するための土台です。現在は React + TypeScript + Vite を使ったクリーンなスケルトンのみを含み、今後以下の要素を追加していきます。

- クライアント内で完結するシーン遷移
- ピンやフィードバックを PNG 画像でアニメーション表示
- クリックやドラッグなどのマウス・タッチ操作検知
- MasterMind の判定ロジックとスコア管理

## セットアップ手順

```bash
npm install        # 依存ライブラリをインストール
npm run dev        # Vite の開発サーバー（HMR 付き）を起動
npm run build      # 型チェックと本番ビルドを実行
npm run preview    # 本番ビルドをローカルで確認
```

Vite が提供する標準ツール群（ESLint、SWC ベースの React プラグイン、TypeScript プロジェクト参照など）をそのまま利用しています。ゲームロジックやアセットパイプラインを整えながら、`tsconfig*.json`、`vite.config.ts`、`eslint.config.js` などを適宜調整してください。

## 今後のタスク（例）

- `ios/` にあるアセットを `public/` 配下にブラウザー向けのスプライト／PNG として移植
- `src/` 内に MasterMind 盤面と判定ロジックを実装
- UI が整い次第、Vitest + Testing Library などで操作テストを追加
