import { connect } from 'react-redux';

import AssetsPage from '.';
import { getAssets, clearFilters } from '../../data/actions/assets';


const mapStateToProps = state => ({
  assetsList: state.assets,
  courseDetails: state.studioDetails.course,
  uploadSettings: state.studioDetails.upload_settings,
  status: state.metadata.status,
  filtersMetaData: state.metadata.filters,
});

const mapDispatchToProps = dispatch => ({
  clearFilters: courseDetails => dispatch(clearFilters(courseDetails)),
  getAssets: (request, courseDetails) => dispatch(getAssets(request, courseDetails)),
});

const WrappedAssetsPage = connect(
  mapStateToProps,
  mapDispatchToProps,
)(AssetsPage);

export default WrappedAssetsPage;